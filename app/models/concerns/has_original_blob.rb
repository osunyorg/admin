module HasOriginalBlob
  extend ActiveSupport::Concern

  included do
    belongs_to  :original_blob,
                class_name: 'ActiveStorage::Blob'

    attr_accessor :original_uploaded_file

    before_validation :create_original_blob_from_upload, on: :create, if: :original_uploaded_file

    validates :original_uploaded_file, presence: true, on: :create, unless: :original_blob
  end

  class_methods do

    protected

    def create_context(object, blob, about)
      object.contexts.where(
        about: about,
        active_storage_blob: blob, # absent dans les files
        university_id: blob.university_id
      ).first_or_create
    end
  end

  # TODO Quand on voudra généraliser l'usage (pas seulement les featured_images)
  # il faudra ajouter la clé au contexte (le même média peut être utilisé pour 2 clés différentes).
  def attach(about, key)
    # Création du nouveau contexte
    contexts.where(
      university: university,
      active_storage_blob: original_blob,
      about: about
    ).first_or_create
    # Attachement du nouveau blob
    ActiveStorage::Attachment.where(
      name: key,
      blob: original_blob,
      record: about
    ).first_or_create
  end

  def original_blob=(value)
    super(value)
    return if value.blank?
    self.original_checksum = value.checksum
    self.original_filename = value.filename.to_s
    self.original_content_type = value.content_type
    self.original_byte_size = value.byte_size
  end

  protected

  def create_original_blob_from_upload
    return if wrong_uploaded_file? || file_size_too_big?
    original_uploaded_file_io = original_uploaded_file.open
    blob = build_blob_from_upload(original_uploaded_file_io)
    return if exists_for_blob_checksum?(blob)
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

  def exists_for_blob_checksum?(blob)
    objects = self.class.where(university_id: university.id)
    if objects.where(original_checksum: blob.checksum).any?
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
