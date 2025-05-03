# == Schema Information
#
# Table name: communication_extranet_document_category_localizations
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
#  idx_on_about_id_23f2406431       (about_id)
#  idx_on_extranet_id_14250ebc96    (extranet_id)
#  idx_on_language_id_97c91dbc2f    (language_id)
#  idx_on_university_id_5fd0a2ba37  (university_id)
#
# Foreign Keys
#
#  fk_rails_1ead1e0fb8  (about_id => communication_extranet_document_categories.id)
#  fk_rails_347ec5178a  (extranet_id => communication_extranets.id)
#  fk_rails_a1a315d533  (university_id => universities.id)
#  fk_rails_c87b1b79d4  (language_id => languages.id)
#
class Communication::Extranet::Document::Category::Localization < ApplicationRecord
  include AsIndirectObject
  include AsLocalization
  include Initials
  include Sluggable

  validates :name, presence: true

  belongs_to  :extranet, 
              class_name: 'Communication::Extranet'

  before_validation :set_extranet_id, on: :create

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
