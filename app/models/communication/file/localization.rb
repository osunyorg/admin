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
  include WithIcon
  include WithOpenApi
  include WithUniversity

  belongs_to  :original_blob,
              class_name: 'ActiveStorage::Blob'

  attr_accessor :original_uploaded_file

  before_validation :create_original_blob_from_upload, on: :create, if: :original_uploaded_file

  validates :original_uploaded_file, presence: true, on: :create, unless: :original_blob

  def original_blob=(value)
    super(value)
    return if value.blank?
    self.original_checksum = value.checksum
    self.original_filename = value.filename.to_s
    self.original_content_type = value.content_type
    self.original_byte_size = value.byte_size
  end

  def to_s
    "#{name}"
  end

  protected

  def create_original_blob_from_upload
    return if wrong_uploaded_file? || file_size_too_big?
    original_uploaded_file_io = original_uploaded_file.open
    blob = build_blob_from_upload(original_uploaded_file_io)
    return if file_exists_for_blob_checksum?(blob)
    # Blob is not a duplicate, we can save it and upload the file
    blob.save!
    # https://apidock.com/rails/v7.0.0/ActiveStorage/Blob/upload_without_unfurling
    blob.upload_without_unfurling(original_uploaded_file_io)
    blob.update_column :university_id, university_id
    self.original_blob = blob
  end

  def wrong_uploaded_file?
    if !original_uploaded_file.is_a?(ActionDispatch::Http::UploadedFile)
      errors.add :original_uploaded_file, :no_file
      true
    else
      false
    end
  end

  def file_size_too_big?
    if original_uploaded_file.size > Rails.application.config.default_image_max_size
      errors.add :original_uploaded_file, :too_big
      true
    else
      false
    end
  end

  def file_exists_for_blob_checksum?(blob)
    if university.communication_file_localizations.where(original_checksum: blob.checksum).any?
      errors.add :original_uploaded_file, :already_imported
      true
    else
      false
    end
  end

  def build_blob_from_upload(io)
    # We don't use create_and_upload! method as persisting the blob and uploading the file might be useless.
    # Instead, we use the build_and_unfurl method of the Blob class:
    # - Build will initialize a new Blob object
    # - Unfurl will calculate the checksum, the content type and the byte size
    # https://apidock.com/rails/v7.0.0/ActiveStorage/Blob/build_after_unfurling/class
    ActiveStorage::Blob.build_after_unfurling(
      io: io,
      filename: original_uploaded_file.original_filename,
      content_type: original_uploaded_file.content_type
    )
  end
end
