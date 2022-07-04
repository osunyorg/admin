# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  breadcrumb_title         :string
#  description              :text
#  description_short        :text
#  featured_image_alt       :string
#  featured_image_credit    :text
#  github_path              :text
#  header_text              :text
#  kind                     :integer
#  path                     :text
#  position                 :integer          default(0), not null
#  published                :boolean          default(FALSE)
#  slug                     :string
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_language_id               (language_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1a42003f06  (parent_id => communication_website_pages.id)
#  fk_rails_280107c62b  (communication_website_id => communication_websites.id)
#  fk_rails_d208d15a73  (university_id => universities.id)
#

class Communication::Website::Page < ApplicationRecord
  include Sanitizable
  include WithUniversity
  include WithBlobs
  include WithBlocks
  include WithGit
  include WithFeaturedImage
  include WithKind
  include WithMenuItemTarget
  include WithPosition
  include WithTree
  include Accessible

  has_summernote :text

  belongs_to :website,
             foreign_key: :communication_website_id
  belongs_to :parent,
             class_name: 'Communication::Website::Page',
             optional: true
  belongs_to :language, optional: true
  has_one    :imported_page,
             class_name: 'Communication::Website::Imported::Page',
             dependent: :nullify
  has_many   :children,
             class_name: 'Communication::Website::Page',
             foreign_key: :parent_id,
             dependent: :destroy

  validates :title, presence: true

  validates :slug,
            presence: true,
            unless: :kind_home?
  validate  :slug_must_be_unique
  validates :slug,
            format: {
              with: /\A[a-z0-9\-]+\z/,
              message: I18n.t('slug_error')
            },
            unless: :kind_home?

  before_validation :check_slug, :make_path
  after_save :update_children_paths, if: :saved_change_to_path?

  scope :recent, -> { order(updated_at: :desc).limit(5) }
  scope :published, -> { where(published: true) }

  def generated_path
    "#{parent&.path}#{slug}/".gsub(/\/+/, '/')
  end

  def path_without_language
    if kind_home?
      "/"
    elsif parent_id.present?
      "#{parent&.path_without_language}#{slug}/".gsub(/\/+/, '/')
    else
      "/#{slug}/".gsub(/\/+/, '/')
    end
  end

  def git_path(website)
    return unless published
    if kind_home?
      "content/_index.html"
    elsif is_special_page? && SPECIAL_PAGES_WITH_GIT_SPECIAL_PATH.include?(kind)
      "content/#{kind.split('_').last}/_index.html"
    else
      "content/pages/#{path}/_index.html"
    end
  end

  def template_static
    "admin/communication/websites/pages/static"
  end

  def git_dependencies(website)
    dependencies = [self] +
                    website.menus +
                    descendants +
                    active_storage_blobs +
                    siblings +
                    git_block_dependencies
    dependencies += website.education_programs if kind_education_programs?
    dependencies += [parent] if has_parent?
    dependencies += [website.config_permalinks] if is_special_page?
    dependencies.flatten
  end

  def git_destroy_dependencies(website)
    [self] +
    descendants +
    active_storage_blobs
  end

  def url
    return unless published
    return if website.url.blank?
    "#{website.url}#{path}"
  end

  def language_prefix
    "/#{language.iso_code}" if website.languages.any? && language_id
  end

  def duplicate
    page = self.dup
    page.published = false
    page.save
    blocks.each do |block|
      b = block.duplicate
      b.about = page
      b.save
    end
    page
  end

  def to_s
    "#{title}"
  end

  def best_featured_image
    # we don't want to fallback on homepage featured_image
    return featured_image if featured_image.attached? || kind_home? || parent&.kind_home?
    parent&.best_featured_image
  end

  def best_bodyclass
    return bodyclass if bodyclass.present?
    parent&.best_bodyclass unless kind_home? || parent&.kind_home?
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

  def check_accessibility
    accessibility_merge_array blocks
  end

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
    self.path = kind_home? ? "#{language_prefix}/" : generated_path
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
