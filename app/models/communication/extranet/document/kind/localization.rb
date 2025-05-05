# == Schema Information
#
# Table name: communication_extranet_document_kind_localizations
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed
#  extranet_id   :uuid             indexed
#  language_id   :uuid             indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_0cd2750c0e       (about_id)
#  idx_on_extranet_id_39af5dfd8e    (extranet_id)
#  idx_on_language_id_a4b9bfa7ba    (language_id)
#  idx_on_university_id_0dc1259072  (university_id)
#
# Foreign Keys
#
#  fk_rails_192d1def98  (extranet_id => communication_extranets.id)
#  fk_rails_534d24c00a  (about_id => communication_extranet_document_kinds.id)
#  fk_rails_b78a2800f3  (language_id => languages.id)
#  fk_rails_fe1c677982  (university_id => universities.id)
#
class Communication::Extranet::Document::Kind::Localization < ApplicationRecord
  include AsIndirectObject
  include AsLocalization
  include Initials
  include Sluggable

  belongs_to  :extranet, 
              class_name: 'Communication::Extranet'

  before_validation :set_extranet_id, on: :create

  validates :name, presence: true

  def to_s
    "#{name}"
  end

  protected

  def set_extranet_id
    self.extranet_id ||= about.extranet_id
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(
                extranet_id: extranet_id, 
                language_id: language_id,
                slug: slug
              )
              .where.not(id: id)
              .exists?
  end
end
