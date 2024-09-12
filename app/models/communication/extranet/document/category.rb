# == Schema Information
#
# Table name: communication_extranet_document_categories
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string           indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  extranet_document_categories_universities                        (university_id)
#  index_communication_extranet_document_categories_on_extranet_id  (extranet_id)
#  index_communication_extranet_document_categories_on_slug         (slug)
#
# Foreign Keys
#
#  fk_rails_6f2232d9f8  (university_id => universities.id)
#  fk_rails_76e327b90f  (extranet_id => communication_extranets.id)
#
class Communication::Extranet::Document::Category < ApplicationRecord
  include Localizable
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'

  has_many :communication_extranet_documents, class_name: "Communication::Extranet::Document"
  alias_method :documents, :communication_extranet_documents

  # TODO
  scope :ordered, -> (language) { }
end
