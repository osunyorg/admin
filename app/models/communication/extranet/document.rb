# == Schema Information
#
# Table name: communication_extranet_documents
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :uuid             indexed
#  extranet_id   :uuid             not null, indexed
#  kind_id       :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  extranet_document_categories                             (category_id)
#  index_communication_extranet_documents_on_extranet_id    (extranet_id)
#  index_communication_extranet_documents_on_university_id  (university_id)
#  index_extranet_document_kinds                            (kind_id)
#
# Foreign Keys
#
#  fk_rails_1272fd263c  (extranet_id => communication_extranets.id)
#  fk_rails_51f7db2f66  (kind_id => communication_extranet_document_kinds.id)
#  fk_rails_af877a8c0c  (university_id => universities.id)
#  fk_rails_eb351dc444  (category_id => communication_extranet_document_categories.id)
#
class Communication::Extranet::Document < ApplicationRecord
  include Sanitizable
  include Localizable
  include LocalizableOrderByNameScope
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'
  belongs_to :category
  belongs_to :kind

  validates :category, :kind, presence: true

  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(communication_extranet_document_localizations: { language_id: language.id })
      .where("
        unaccent(communication_extranet_document_localizations.name) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }

end
