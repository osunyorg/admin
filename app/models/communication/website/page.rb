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
#  full_width               :boolean          default(FALSE)
#  github_path              :text
#  header_text              :text
#  kind                     :integer
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
  self.ignored_columns = %w(path)

  include Accessible
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
  include WithPath
  include WithPermalink

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

  scope :recent, -> { order(updated_at: :desc).limit(5) }
  scope :published, -> { where(published: true) }

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
    dependencies += [parent] if has_parent?
    dependencies += special_page_git_dependencies(website) if is_special_page?
    dependencies.flatten
  end

  def git_destroy_dependencies(website)
    [self] +
    descendants +
    active_storage_blobs
  end

  def duplicate
    page = self.dup
    page.published = false
    page.save
    blocks.ordered.each do |block|
      b = block.duplicate
      b.about = page
      b.save
    end
    page
  end

  def full_width
    kind_home?  ? true
                : attributes['full_width']
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

  def siblings
    self.class.unscoped
              .where(parent: parent, university: university, website: website)
              .where.not(id: id)
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def last_ordered_element
    website.pages.where(parent_id: parent_id).ordered.last
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
