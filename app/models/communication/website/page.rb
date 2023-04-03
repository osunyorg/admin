# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  breadcrumb_title         :string
#  featured_image_alt       :string
#  featured_image_credit    :text
#  full_width               :boolean          default(FALSE)
#  github_path              :text
#  header_text              :text
#  kind                     :integer
#  meta_description         :text
#  position                 :integer          default(0), not null
#  published                :boolean          default(FALSE)
#  slug                     :string
#  summary                  :text
#  text                     :text
#  title                    :string
#  type                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_language_id               (language_id)
#  index_communication_website_pages_on_original_id               (original_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1a42003f06  (parent_id => communication_website_pages.id)
#  fk_rails_280107c62b  (communication_website_id => communication_websites.id)
#  fk_rails_304f57360f  (original_id => communication_website_pages.id)
#  fk_rails_d208d15a73  (university_id => universities.id)
#

class Communication::Website::Page < ApplicationRecord
  self.ignored_columns = %w(path)

  include Accessible
  include Sanitizable
  include WithBlobs
  include WithBlocks
  include WithDuplication
  include WithFeaturedImage
  include WithGit
  include WithMenuItemTarget
  include WithPosition
  include WithTree
  include WithPermalink
  include WithType
  include WithTranslations
  # WithPath overwrite the git_path method defined in WithWebsites
  include WithPath
  include WithUniversity

  has_summernote :text # TODO: Remove text attribute

  belongs_to :website,
             foreign_key: :communication_website_id
  belongs_to :parent,
             class_name: 'Communication::Website::Page',
             optional: true
  belongs_to :original,
             class_name: 'Communication::Website::Page',
             optional: true
  belongs_to :language
  has_one    :imported_page,
             class_name: 'Communication::Website::Imported::Page',
             dependent: :nullify
  has_many   :children,
             class_name: 'Communication::Website::Page',
             foreign_key: :parent_id,
             dependent: :destroy
  has_many   :translations,
             class_name: 'Communication::Website::Page',
             foreign_key: :original_id
             
  validates :title, presence: true

  scope :recent, -> { order(updated_at: :desc).limit(5) }
  scope :published, -> { where(published: true) }

  def template_static
    "admin/communication/websites/pages/static"
  end
  
  def menu_items
    Communication::Website::Menu::Item.where(website: website, kind: :page, about: self)
  end

  def dependencies
    active_storage_blobs +
    blocks +
    menu_items +
    children
  end

  def to_s
    "#{title}"
  end

  def best_featured_image_source(fallback: true)
    # we don't want to fallback on homepage featured_image
    return self if featured_image.attached? || is_home? || parent&.is_home?
    parent&.best_featured_image_source
  end

  def best_bodyclass
    return bodyclass if bodyclass.present?
    parent&.best_bodyclass unless is_home? || parent&.is_home?
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
    website.pages.where(parent_id: parent_id, language_id: language_id).ordered.last
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
