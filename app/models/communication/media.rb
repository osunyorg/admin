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
  include Categorizable
  include Filterable
  include Localizable
  include LocalizableOrderByNameScope
  include WithUniversity

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

  scope :for_search_term, -> (term, language = nil) {
    joins(:localizations)
    .where(communication_media_localizations: { language_id: language.id })
    .where("
      unaccent(communication_media_localizations.name) ILIKE unaccent(:term) OR
      unaccent(communication_media_localizations.alt) ILIKE unaccent(:term) OR
      unaccent(communication_media_localizations.credit) ILIKE unaccent(:term)
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

  def attach(about, key)
    # TODO il faut enlever les blobs des contextes (c'est le même que le média) et ajouter la clé (le même média peut être utilisé pour 2 clés différentes)
    # TODO supprimer le contexte du média d'avant
    # Création du contexte
    contexts.where(
      university: university,
      active_storage_blob: original_blob,
      about: about
    ).first_or_create
    # Détachement du blob précédent
    ActiveStorage::Attachment.where(
      name: key,
      record: about
    ).destroy_all
    # Attachement du nouveau blob
    ActiveStorage::Attachment.create(
      name: key,
      blob: original_blob,
      record: about
    )
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
      media.original_filename = blob.filename
      media.original_content_type = blob.content_type
      media.original_byte_size = blob.byte_size
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
end
