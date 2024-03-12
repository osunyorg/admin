# == Schema Information
#
# Table name: communication_website_portfolio_projects
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  meta_description         :text
#  published                :boolean          default(FALSE)
#  slug                     :string
#  summary                  :text
#  title                    :string
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_aac12e3adb                     (communication_website_id)
#  idx_on_university_id_ac2f4a0bfc                                (university_id)
#  index_communication_website_portfolio_projects_on_language_id  (language_id)
#  index_communication_website_portfolio_projects_on_original_id  (original_id)
#
# Foreign Keys
#
#  fk_rails_5c5fb357a3  (original_id => communication_website_portfolio_projects.id)
#  fk_rails_6b220c2717  (communication_website_id => communication_websites.id)
#  fk_rails_810f9f3908  (language_id => languages.id)
#  fk_rails_a2d39c0893  (university_id => universities.id)
#
class Communication::Website::Portfolio::Project < ApplicationRecord
  include AsDirectObject
  include Contentful
  include Sanitizable
  include Sluggable
  include WithAccessibility
  include WithBlobs
  include WithDuplication
  include WithFeaturedImage
  include WithMenuItemTarget
  include WithPermalink
  include WithTranslations
  include WithUniversity

  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Portfolio::Category',
                          join_table: :communication_website_portfolio_categories_projects,
                          foreign_key: :communication_website_portfolio_project_id,
                          association_foreign_key: :communication_website_portfolio_category_id

  validates :title, :year, presence: true

  scope :ordered, -> { order(year: :desc, title: :asc) }
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }

  def git_path(website)
    return unless website.id == communication_website_id && published
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "projects/#{year}-#{slug}.html"
  end

  def template_static
    "admin/communication/websites/portfolio/projects/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies +
    [website.config_default_content_security_policy]
  end

  def references
    menus +
    abouts_with_agenda_block
  end

  def url
    return unless published
    return if website.url.blank?
    return if website.special_page(Communication::Website::Page::CommunicationAgenda)&.path.blank?
    return if current_permalink_in_website(website).blank?
    "#{Static.remove_trailing_slash website.url}#{Static.clean_path current_permalink_in_website(website).path}"
  end

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def abouts_with_agenda_block
    website.blocks.agenda.collect(&:about)
  end

end
