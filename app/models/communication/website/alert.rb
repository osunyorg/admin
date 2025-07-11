class Communication::Website::Alert < ApplicationRecord
  include AsDirectObject
  include Filterable
  include GeneratesGitFiles
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
