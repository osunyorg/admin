# == Schema Information
#
# Table name: communication_extranet_post_category_localizations
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
#  idx_on_about_id_ff80179dbe       (about_id)
#  idx_on_extranet_id_aeb5898555    (extranet_id)
#  idx_on_language_id_87a464170d    (language_id)
#  idx_on_university_id_1b84e09ad5  (university_id)
#
# Foreign Keys
#
#  fk_rails_4f55793091  (extranet_id => communication_extranets.id)
#  fk_rails_98b43e0d3a  (language_id => languages.id)
#  fk_rails_da14f397d9  (university_id => universities.id)
#  fk_rails_ef1682777f  (about_id => communication_extranet_post_categories.id)
#
class Communication::Extranet::Post::Category::Localization < ApplicationRecord
  include AsLocalization
  include Initials
  include Sanitizable
  include Sluggable
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'

  validates_presence_of :name

  before_validation :set_extranet_id, on: :create

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

  def set_extranet_id
    self.extranet_id ||= about.extranet_id
  end
end
