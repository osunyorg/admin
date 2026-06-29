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
  include WithIcon
  include WithOpenApi
  include WithUniversity

  has_many    :contexts,
              foreign_key: :communication_file_id,
              dependent: :destroy
  has_many.   :blobs,
              through: :contexts,
              source: :active_storage_blob

  def to_s
    "#{name}"
  end
end
