# == Schema Information
#
# Table name: communication_media_localizations
#
#  id                   :uuid             not null, primary key
#  alt                  :text
#  credit               :text
#  deleted_at           :datetime         indexed
#  internal_description :text
#  name                 :string
#  published            :boolean          default(FALSE)
#  published_at         :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  about_id             :uuid             not null, uniquely indexed => [language_id], indexed
#  language_id          :uuid             not null, uniquely indexed => [about_id], indexed
#  university_id        :uuid             not null, indexed
#  updated_by_id        :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_fec28c8838                    (about_id,language_id) UNIQUE
#  index_communication_media_localizations_on_about_id       (about_id)
#  index_communication_media_localizations_on_deleted_at     (deleted_at)
#  index_communication_media_localizations_on_language_id    (language_id)
#  index_communication_media_localizations_on_university_id  (university_id)
#  index_communication_media_localizations_on_updated_by_id  (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_1d4f5d7ce1  (updated_by_id => users.id)
#  fk_rails_35f58fb543  (language_id => languages.id)
#  fk_rails_6d73968a83  (about_id => communication_medias.id)
#  fk_rails_e7e1203351  (university_id => universities.id)
#
class Communication::Media::Localization < ApplicationRecord
  acts_as_paranoid

  include AsLocalization
  include HasUniversity
  include Initials
  include Publishable
  include WithOpenApi

  belongs_to  :updated_by,
              class_name: 'User',
              optional: true

  before_validation :guess_name

  has_summernote :credit

  def blob
    about.original_blob
  end

  def blob_if_published
    blob if published?
  end

  def to_s
    "#{name}"
  end

  protected

  def guess_name
    return if self.name.present?
    self.name = media.original_guessed_name
  end

end
