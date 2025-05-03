# == Schema Information
#
# Table name: communication_media_localizations
#
#  id                   :uuid             not null, primary key
#  alt                  :text
#  credit               :text
#  internal_description :text
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  about_id             :uuid             not null, indexed
#  language_id          :uuid             not null, indexed
#  university_id        :uuid             not null, indexed
#
# Indexes
#
#  index_communication_media_localizations_on_about_id       (about_id)
#  index_communication_media_localizations_on_language_id    (language_id)
#  index_communication_media_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_35f58fb543  (language_id => languages.id)
#  fk_rails_6d73968a83  (about_id => communication_medias.id)
#  fk_rails_e7e1203351  (university_id => universities.id)
#
class Communication::Media::Localization < ApplicationRecord
  include AsIndirectObject
  include AsLocalization
  include Initials
  include WithUniversity

  def to_s
    "#{name}"
  end
end
