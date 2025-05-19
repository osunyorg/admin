# == Schema Information
#
# Table name: communication_website_jobboard_jobs
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  from_day                 :date
#  to_day                   :date
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  created_by_id            :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_jobboard_jobs_on_created_by_id  (created_by_id)
#  index_communication_website_jobboard_jobs_on_university_id  (university_id)
#  index_jobboard_jobs_on_communication_website_id             (communication_website_id)
#
# Foreign Keys
#
#  fk_rails_2136aaff0b  (created_by_id => users.id)
#  fk_rails_44dd13fbb2  (communication_website_id => communication_websites.id)
#  fk_rails_d02e78c48b  (university_id => universities.id)
#
class Communication::Website::Jobboard::Job < ApplicationRecord
  include AsDirectObject
  include Duplicable
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include GeneratesGitFiles
  include Localizable
  include Sanitizable
  include Searchable
  include WithUniversity

  belongs_to  :created_by,
              class_name: "User",
              optional: true

  scope :ordered_desc, -> {
    order(from_day: :desc, created_at: :desc)
  }
  scope :ordered_asc, -> {
    order(from_day: :asc, created_at: :asc)
  }
  scope :ordered, -> (language = nil) { ordered_asc }

  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(communication_website_jobboard_job_localizations: { language_id: language.id })
      . where("
      unaccent(communication_website_jobboard_job_localizations.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_jobboard_job_localizations.description) ILIKE unaccent(:term) OR
      unaccent(communication_website_jobboard_job_localizations.title) ILIKE unaccent(:term) OR
      unaccent(communication_website_jobboard_job_localizations.subtitle) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids) 
  end
 
end
