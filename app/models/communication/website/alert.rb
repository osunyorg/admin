# == Schema Information
#
# Table name: communication_website_alerts
#
#  id                       :uuid             not null, primary key
#  kind                     :integer          default("info"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_alerts_on_communication_website_id  (communication_website_id)
#  index_communication_website_alerts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_5ec8e3c4a2  (university_id => universities.id)
#  fk_rails_7c40424e19  (communication_website_id => communication_websites.id)
#
class Communication::Website::Alert < ApplicationRecord
  acts_as_paranoid

  include AsDirectObject
  include Filterable
  include GeneratesGitFiles
  include Lifecyclable
  include Localizable
  include LocalizableOrderByTitleScope
  include Sanitizable
  include Searchable
  include WithUniversity

  enum :kind, { info: 0, warning: 50, danger: 100 }

  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(communication_website_alert_localizations: { language_id: language.id })
      .where("
        unaccent(communication_website_alert_localizations.description) ILIKE unaccent(:term) OR
        unaccent(communication_website_alert_localizations.title) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_kind, -> (kind) { where(kind: kind) }

  def dependencies
    localizations.in_languages(website.active_language_ids)
  end
end
