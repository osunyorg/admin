# == Schema Information
#
# Table name: communication_website_portfolio_project_localizations
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  header_cta               :boolean          default(FALSE)
#  header_cta_label         :string
#  header_cta_url           :string
#  meta_description         :string
#  migration_identifier     :string
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :string
#  subtitle                 :string
#  summary                  :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             indexed
#  language_id              :uuid             indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_a668ef6090                  (about_id)
#  idx_on_communication_website_id_e653b6273a  (communication_website_id)
#  idx_on_language_id_25a0c1e472               (language_id)
#  idx_on_university_id_f01fc2c686             (university_id)
#
# Foreign Keys
#
#  fk_rails_3145135b3c  (communication_website_id => communication_websites.id)
#  fk_rails_be29689be2  (language_id => languages.id)
#  fk_rails_c1a10dcae3  (university_id => universities.id)
#  fk_rails_fbc92c5948  (about_id => communication_website_portfolio_projects.id)
#
class Communication::Website::Portfolio::Project::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include HeaderCallToAction
  include Initials
  include Migratable
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithPublication
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  has_summernote :summary

  validates :title, presence: true
  before_validation :set_communication_website_id, on: :create

  scope :ordered, -> (language = nil) { order(year: :desc, title: :asc) }
  scope :latest, -> { published.order(updated_at: :desc).limit(5) }

  def git_path(website)
    return unless website.id == communication_website_id && published
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "projects/#{about.year}-#{slug}.html"
  end

  def template_static
    "admin/communication/websites/portfolio/projects/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id
    ]
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end

end
