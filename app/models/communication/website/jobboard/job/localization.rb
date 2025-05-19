# == Schema Information
#
# Table name: communication_website_jobboard_job_localizations
#
#  id                       :uuid             not null, primary key
#  description              :text
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
#  idx_on_about_id_8bbb00c89f                  (about_id)
#  idx_on_communication_website_id_3e7b95d239  (communication_website_id)
#  idx_on_language_id_d4c8ef57a7               (language_id)
#  idx_on_university_id_dfeba87c37             (university_id)
#
# Foreign Keys
#
#  fk_rails_26cba6d1df  (about_id => communication_website_jobboard_jobs.id)
#  fk_rails_3cfb020b16  (university_id => universities.id)
#  fk_rails_ac8b0db85a  (communication_website_id => communication_websites.id)
#  fk_rails_f02e8cacb5  (language_id => languages.id)
#
class Communication::Website::Jobboard::Job::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include HasGitFiles
  include HeaderCallToAction
  include Initials
  include Permalinkable # slug_unavailable method overwrite in this file
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithPublication
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :job :about

  has_summernote :description

  validates :title, :description, presence: true

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    return unless website.id == communication_website_id && published && published_at
    git_path_content_prefix(website) + git_path_relative
  end

  # jobs/2025/01/01-nom-offre.html
  def git_path_relative
    "jobs/#{from_day.strftime "%Y/%m/%d"}-#{slug}.html"
  end

  def template_static
    "admin/communication/websites/jobboard/jobs/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def categories
    about.categories.ordered.map { |category| category.localization_for(language) }.compact
  end

  def to_s
    "#{title}"
  end

  def to_s_with_subtitle
    [title, subtitle].compact_blank.join(' - ')
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .left_joins(:about)
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .where("date_part('year', communication_website_jobboard_jobs.from_day) = ?", about.from_day&.year)
              .exists?
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id
    ]
  end

  def localize_other_attachments(localization)
    localize_attachment(localization, :shared_image) if shared_image.attached?
  end

end
