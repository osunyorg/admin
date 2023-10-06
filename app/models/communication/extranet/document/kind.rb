# == Schema Information
#
# Table name: communication_extranet_document_kinds
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  extranet_document_kinds_universities                        (university_id)
#  index_communication_extranet_document_kinds_on_extranet_id  (extranet_id)
#
# Foreign Keys
#
#  fk_rails_27a9b91ed8  (extranet_id => communication_extranets.id)
#  fk_rails_2a55cf899a  (university_id => universities.id)
#
class Communication::Extranet::Document::Kind < ApplicationRecord
  include WithSlug
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'

  has_many :communication_extranet_documents, class_name: "Communication::Extranet::Document"
  alias_method :documents, :communication_extranet_documents

  validates :name, presence: true

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(extranet_id: self.extranet_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end
end
