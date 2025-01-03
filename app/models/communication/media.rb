# == Schema Information
#
# Table name: communication_medias
#
#  id            :uuid             not null, primary key
#  byte_size     :bigint
#  content_type  :string
#  digest        :string
#  filename      :string
#  origin        :integer          default("content"), not null
#  variant       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  blob_id       :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_medias_on_blob_id        (blob_id)
#  index_communication_medias_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_76c854d206  (blob_id => active_storage_blobs.id)
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

  belongs_to              :blob,
                          class_name: 'ActiveStorage::Blob'
  has_and_belongs_to_many :blobs,
                          class_name: 'ActiveStorage::Blob',
                          foreign_key: :communication_media_id,
                          association_foreign_key: :active_storage_blob_id,
                          join_table: :active_storage_blobs_communication_medias,
                          uniq: true
  has_many                :attachments, 
                          through: :blobs,
                          class_name: 'ActiveStorage::Attachment'

  after_create :create_original_localization

  default_scope { where(variant: false) }

  def self.create_from_blob(blob)
    digest = compute_digest(blob)
    puts "create blob #{blob.id} [#{digest}]"
    media = Communication::Media.unscoped.where(
        university: blob.university_id,
        digest: digest,
      ).first_or_create do |media|
      # On creation, we set the original blob, so we can find variants afterwards
      media.blob = blob
      media.filename = blob.filename
      media.content_type = blob.content_type
      media.byte_size = blob.byte_size
    end
    media.blobs << blob
    media
  end

  def self.discard_variant(variant)
    media = create_from_blob(variant.image.blob)
    # Le media est-il le bon ?
    media.discard!
    puts "discard variant #{media.blob.id} [#{media.digest}]"
  end

  def discard!
    update_column :variant, true
  end

  protected

  def self.compute_digest(blob)
    Digest::SHA2.hexdigest blob.download
  end

  def create_original_localization
    l10n = localizations.where(language: university.default_language).first_or_create
    l10n.name = filename
    l10n.save
  end
end
