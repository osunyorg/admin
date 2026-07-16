# == Schema Information
#
# Table name: communication_file_localizations
#
#  id                    :uuid             not null, primary key
#  internal_description  :text
#  name                  :string
#  original_byte_size    :bigint
#  original_checksum     :string
#  original_content_type :string
#  original_filename     :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             not null, indexed
#  language_id           :uuid             not null, indexed
#  original_blob_id      :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_communication_file_localizations_on_about_id          (about_id)
#  index_communication_file_localizations_on_language_id       (language_id)
#  index_communication_file_localizations_on_original_blob_id  (original_blob_id)
#  index_communication_file_localizations_on_university_id     (university_id)
#
# Foreign Keys
#
#  fk_rails_2caf77cf04  (original_blob_id => active_storage_blobs.id)
#  fk_rails_38de4b5d8a  (language_id => languages.id)
#  fk_rails_6f750651f5  (about_id => communication_files.id)
#  fk_rails_fcfa27eb47  (university_id => universities.id)
#
class Communication::File::Localization < ApplicationRecord
  include AsLocalization
  include HasOriginalBlob
  include HasUniversity
  include WithOpenApi

  has_many    :contexts,
              foreign_key: :communication_file_localization_id,
              dependent: :destroy
  has_many    :blobs,
              through: :contexts,
              source: :active_storage_blob
  alias :file :about

  def self.create_from_blob(blob, language)
    localization = where(
      university_id: blob.university_id,
      language_id: language.id,
      original_checksum: blob.checksum
    ).first_or_create do |localization|
      file = Communication::File.find_or_create_for_blob(blob)
      # On attribue le blob
      localization.original_blob = blob
      # On connecte au fichier
      localization.about_id = file.id
      # On prend le nom du fichier comme nom par défaut (c'est mieux que rien)
      localization.name = blob.filename.to_s
    end
    localization
  end

  def max_file_size
    Rails.application.config.default_file_max_size
  end

  def icon
    @icon ||= Osuny::FileType.icon_for(original_content_type)
  end

  def to_s
    "#{name}"
  end
end
