# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  about_type               :string           indexed => [about_id]
#  description              :text
#  description_short        :text
#  featured_image_alt       :string
#  github_path              :text
#  old_text                 :text
#  path                     :text
#  position                 :integer          default(0), not null
#  published                :boolean          default(FALSE)
#  slug                     :string
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed => [about_type]
#  communication_website_id :uuid             not null, indexed
#  parent_id                :uuid             indexed
#  related_category_id      :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_pages_on_about                     (about_type,about_id)
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_related_category_id       (related_category_id)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1a42003f06  (parent_id => communication_website_pages.id)
#  fk_rails_280107c62b  (communication_website_id => communication_websites.id)
#  fk_rails_47b37cf8b2  (related_category_id => communication_website_categories.id)
#  fk_rails_d208d15a73  (university_id => universities.id)
#

class Communication::Website::Page < ApplicationRecord
  include Sanitizable
  include WithBlobs
  include WithBlocks
  include WithGit
  include WithFeaturedImage
  include WithKind
  include WithMenuItemTarget
  include WithPosition
  include WithTree
  include WithUniversity

  has_summernote :text

  belongs_to :website,
             foreign_key: :communication_website_id
  belongs_to :related_category,
             class_name: 'Communication::Website::Category',
             optional: true
  belongs_to :parent,
             class_name: 'Communication::Website::Page',
             optional: true
  has_one    :imported_page,
             class_name: 'Communication::Website::Imported::Page',
             dependent: :nullify
  has_many   :children,
             class_name: 'Communication::Website::Page',
             foreign_key: :parent_id,
             dependent: :destroy

  validates :title, presence: true

  validates :slug, presence: true, unless: :kind_home?
  validate :slug_must_be_unique
  validates :slug, format: { with: /\A[a-z0-9\-]+\z/, message: I18n.t('slug_error') }, unless: :kind_home?

  before_validation :check_slug, :make_path
  after_save :update_children_paths, if: :saved_change_to_path?

  scope :recent, -> { order(updated_at: :desc).limit(5) }

  def generated_path
    "#{parent&.path}/#{slug}".gsub(/\/+/, '/')
  end

  def git_path(website)
    "content/pages/#{path}/_index.html" if published
  end

  def git_dependencies(website)
    [self] +
    website.menus +
    descendents +
    active_storage_blobs +
    siblings +
    git_block_dependencies
  end

  def git_destroy_dependencies(website)
    [self] +
    descendents +
    active_storage_blobs
  end

  def url
    return unless published
    return if website.url.blank?
    "#{website.url}#{path}"
  end

  def to_s
    "#{title}"
  end

  def best_featured_image(fallback: true)
    return featured_image if featured_image.attached?
    best_image = parent&.best_featured_image(fallback: false)
    best_image ||= featured_image if fallback
    best_image
  end

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    website.pages.where(parent_id: parent_id).ordered.last
  end

  def check_slug
    self.slug = to_s.parameterize if self.slug.blank? && !kind_home?
    current_slug = self.slug
    n = 0
    while slug_unavailable?(self.slug)
      n += 1
      self.slug = [current_slug, n].join('-')
    end
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def make_path
    self.path = generated_path
  end

  def slug_must_be_unique
    errors.add(:slug, ActiveRecord::Errors.default_error_messages[:taken]) if slug_unavailable?(slug)
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
