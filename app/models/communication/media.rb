# == Schema Information
#
# Table name: communication_medias
#
#  id                    :uuid             not null, primary key
#  origin                :integer          default("content"), not null
#  original_byte_size    :bigint
#  original_checksum     :string
#  original_content_type :string
#  original_filename     :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  original_blob_id      :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_communication_medias_on_original_blob_id  (original_blob_id)
#  index_communication_medias_on_university_id     (university_id)
#
# Foreign Keys
#
#  fk_rails_44f0fb11c6  (original_blob_id => active_storage_blobs.id)
#  fk_rails_de56e1762f  (university_id => universities.id)
#
class Communication::Media < ApplicationRecord
  include Filterable
  include Localizable
  include LocalizableOrderByNameScope
  include WithUniversity

  enum :origin, {
    content: 1,   # file uploaded through content (default)
    library: 2,   # file uploaded through media library
    unsplash: 11, # file imported from Unsplash
    pexels: 12    # file imported from Pexels
  }, prefix: :origin

  belongs_to              :original_blob,
                          class_name: 'ActiveStorage::Blob'
  has_many                :contexts,
                          foreign_key: :communication_media_id,
                          dependent: :destroy
  has_many                :blobs,
                          through: :contexts,
                          source: :active_storage_blob

  after_create :create_original_localization

  def self.create_from_blob(blob, in_context:, origin: :content)
    media = Communication::Media.where(
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
    media.contexts.where(
      about: in_context,
      active_storage_blob: blob,
      university_id: blob.university_id
    ).first_or_create
    media
  end

  protected

  def create_original_localization
    l10n = localizations.where(language: university.default_language).first_or_create
    l10n.name = original_filename
    l10n.save
  end
end
