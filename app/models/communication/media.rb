# == Schema Information
#
# Table name: communication_medias
#
#  id                                :uuid             not null, primary key
#  origin                            :integer          default("upload"), not null
#  original_byte_size                :bigint
#  original_checksum                 :string
#  original_content_type             :string
#  original_filename                 :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  communication_media_collection_id :uuid             indexed
#  original_blob_id                  :uuid             not null, indexed
#  university_id                     :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_media_collection_id_6cace98319  (communication_media_collection_id)
#  index_communication_medias_on_original_blob_id       (original_blob_id)
#  index_communication_medias_on_university_id          (university_id)
#
# Foreign Keys
#
#  fk_rails_44f0fb11c6  (original_blob_id => active_storage_blobs.id)
#  fk_rails_abfb984e30  (communication_media_collection_id => communication_media_collections.id)
#  fk_rails_de56e1762f  (university_id => universities.id)
#
class Communication::Media < ApplicationRecord
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include Localizable
  include LocalizableOrderByNameScope
  include WithUniversity

  attr_accessor :original_uploaded_file

  enum :origin, {
    upload: 1,    # file uploaded (default)
    unsplash: 11, # file imported from Unsplash
    pexels: 12    # file imported from Pexels
  }, prefix: :from

  belongs_to              :collection,
                          class_name: 'Communication::Media::Collection',
                          foreign_key: :communication_media_collection_id,
                          optional: true
  belongs_to              :original_blob,
                          class_name: 'ActiveStorage::Blob'
  has_many                :contexts,
                          foreign_key: :communication_media_id,
                          dependent: :destroy
  has_many                :blobs,
                          through: :contexts,
                          source: :active_storage_blob

  before_validation :create_original_blob_from_upload, on: :create, if: :original_uploaded_file

  validates :original_uploaded_file, presence: true, on: :create, unless: :original_blob

  scope :for_search_term, -> (term, language = nil) {
    joins(:localizations)
    .where(communication_media_localizations: { language_id: language.id })
    .where("
      unaccent(communication_media_localizations.name) ILIKE unaccent(:term) OR
      unaccent(communication_media_localizations.alt) ILIKE unaccent(:term) OR
      unaccent(communication_media_localizations.credit) ILIKE unaccent(:term) OR
      unaccent(communication_media_localizations.internal_description) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_origin, -> (origin, language = nil) {
    where(origin: origin)
  }
  scope :for_collection, -> (collection_id, language = nil) {
    where(collection: collection_id)
  }

  def self.create_from_blob(blob, in_context:, origin: :upload, alt: nil, credit: nil)
    return if blob.nil?
    media = find_or_create_media_from_blob(blob, origin)
    create_context(media, blob, in_context)
    find_or_create_media_l10n(media, in_context, alt, credit)
    media
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

  protected

  def self.find_or_create_media_from_blob(blob, origin)
    Communication::Media.where(
        university: blob.university_id,
        original_checksum: blob.checksum,
    ).first_or_create do |media|
      # On creation, we set the original blob, so we can find variants afterwards
      media.origin = origin
      media.original_blob = blob
    end
  end

  def self.create_context(media, blob, about)
    media.contexts.where(
      about: about,
      active_storage_blob: blob,
      university_id: blob.university_id
    ).first_or_create
  end

  def self.find_or_create_media_l10n(media, about, alt, credit)
    l10n = media.localizations.where(
      language: about.language
    ).first_or_initialize
    l10n.name = File.basename(media.original_filename, ".*").humanize
    l10n.alt = alt
    l10n.credit = credit
    l10n.save
  end

  def original_blob=(value)
    super(value)
    self.original_checksum = value.checksum
    self.original_filename = value.filename.to_s
    self.original_content_type = value.content_type
    self.original_byte_size = value.byte_size
  end

  def create_original_blob_from_upload
    return if wrong_uploaded_file? || file_size_too_big?
    original_uploaded_file_io = original_uploaded_file.open
    blob = build_blob_from_upload(original_uploaded_file_io)
    return if media_exists_for_blob_checksum?(blob)
    # Blob is not a duplicate, we can save it and upload the file
    blob.save!
    # https://apidock.com/rails/v7.0.0/ActiveStorage/Blob/upload_without_unfurling
    blob.upload_without_unfurling(original_uploaded_file_io)
    blob.update_column :university_id, university_id
    original_blob = blob
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

  def media_exists_for_blob_checksum?(blob)
    if university.communication_medias.where(original_checksum: blob.checksum).any?
      errors.add :original_uploaded_file, :already_imported
      true
    else
      false
    end
  end
end
