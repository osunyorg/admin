# == Schema Information
#
# Table name: communication_files
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_files_on_created_by_id  (created_by_id)
#  index_communication_files_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_28f27bc358  (university_id => universities.id)
#  fk_rails_e95d85eee7  (created_by_id => users.id)
#
class Communication::File < ApplicationRecord
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include HasUniversity
  include Localizable
  include LocalizableOrderByNameScope
  include WithOpenApi

  scope :for_search_term, -> (term, language = nil) {
    joins(:localizations)
    .where(communication_file_localizations: { language_id: language.id })
    .where("
      unaccent(communication_file_localizations.name) ILIKE unaccent(:term) OR
      unaccent(communication_file_localizations.internal_description) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
end
