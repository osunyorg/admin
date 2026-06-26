# == Schema Information
#
# Table name: communication_files
#
#  id                    :uuid             not null, primary key
#  original_byte_size    :bigint
#  original_checksum     :string
#  original_content_type :string
#  original_filename     :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  original_blob_id      :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_communication_files_on_original_blob_id  (original_blob_id)
#  index_communication_files_on_university_id     (university_id)
#
# Foreign Keys
#
#  fk_rails_28f27bc358  (university_id => universities.id)
#
class Communication::File < ApplicationRecord
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include Localizable
  include LocalizableOrderByNameScope
  include WithOpenApi
  include WithUniversity

  scope :for_search_term, -> (term, language = nil) {
    joins(:localizations)
    .where(communication_file_localizations: { language_id: language.id })
    .where("
      unaccent(communication_file_localizations.name) ILIKE unaccent(:term) OR
      unaccent(communication_file_localizations.internal_description) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
end
