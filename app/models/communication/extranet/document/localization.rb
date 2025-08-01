# == Schema Information
#
# Table name: communication_extranet_document_localizations
#
#  id            :uuid             not null, primary key
#  name          :string
#  published     :boolean          default(FALSE)
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed
#  extranet_id   :uuid             indexed
#  language_id   :uuid             indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_48b91d67ca       (about_id)
#  idx_on_extranet_id_9e28b52a7e    (extranet_id)
#  idx_on_language_id_c5a1e8c320    (language_id)
#  idx_on_university_id_95419f1df4  (university_id)
#
# Foreign Keys
#
#  fk_rails_4722f298b6  (about_id => communication_extranet_documents.id)
#  fk_rails_6864d3f9bb  (language_id => languages.id)
#  fk_rails_c66bfde205  (extranet_id => communication_extranets.id)
#  fk_rails_f87cc9be27  (university_id => universities.id)
#
class Communication::Extranet::Document::Localization < ApplicationRecord
  include AsLocalization
  include Initials
  include Publishable

  belongs_to :extranet, class_name: 'Communication::Extranet'

  has_one_attached_deletable :file

  validates :name, presence: true

  before_validation :set_extranet_id, on: :create

  def to_s
    "#{name}"
  end
  
  protected

  def set_extranet_id
    self.extranet_id ||= about.extranet_id
  end
end
