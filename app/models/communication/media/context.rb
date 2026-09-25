# == Schema Information
#
# Table name: communication_media_contexts
#
#  id                       :uuid             not null, primary key
#  about_type               :string           indexed => [about_id]
#  crop_settings            :jsonb
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed => [about_type]
#  active_storage_blob_id   :uuid             not null, indexed
#  communication_media_id   :uuid             not null, indexed
#  communication_website_id :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_media_contexts_on_about                     (about_type,about_id)
#  index_communication_media_contexts_on_active_storage_blob_id    (active_storage_blob_id)
#  index_communication_media_contexts_on_communication_media_id    (communication_media_id)
#  index_communication_media_contexts_on_communication_website_id  (communication_website_id)
#  index_communication_media_contexts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_2c127ff1c2  (communication_website_id => communication_websites.id)
#  fk_rails_384ccab10a  (active_storage_blob_id => active_storage_blobs.id)
#  fk_rails_47a5ac9f0c  (communication_media_id => communication_medias.id)
#  fk_rails_e118e39a97  (university_id => universities.id)
#
class Communication::Media::Context < ApplicationRecord
  include HasUniversity

  belongs_to  :communication_media,
              class_name: 'Communication::Media'
  alias       :media :communication_media

  belongs_to  :active_storage_blob,
              class_name: 'ActiveStorage::Blob'
  alias       :blob :active_storage_blob

  belongs_to  :communication_website,
              class_name: 'Communication::Website',
              optional: true
  alias       :website :communication_website
 
  belongs_to :about, polymorphic: true

  scope :ordered, -> (language) { order(:about_type) }

  before_save :denormalize_website

  def self.remove(about, except: nil)
    where(university: about.university, about: about)
    .where.not(id: except&.id)
    .delete_all  
  end

  def apply_crop_settings!(crop_settings)
    self.update_column :crop_settings,
                        crop_settings.presence || {}
    @cropper = nil
    if cropper_blob_different?
      self.update_column :active_storage_blob_id, cropped_blob.id
      reload
    end
  end

  def cropped?
    cropper.should_crop?
  end

  def thumb_url
    ENV['KEYCDN_HOST'].present? ? thumb_url_keycdn
                                : thumb_url_rails
  end

  def thumb_url_keycdn
    return unless ENV['KEYCDN_HOST'].present?
    "https://#{ENV['KEYCDN_HOST']}/#{active_storage_blob.key}?width=800"
  end

  def thumb_url_rails
    Rails.application.routes.url_helpers.rails_representation_path(
      active_storage_blob.variant(resize_to_fit: [800, nil]),
      only_path: true
    )
  end

  protected

  def cropper
    @cropper ||= Osuny::Media::Cropper.new(media.original_blob, crop_settings)
  end

  def cropped_blob
    cropper.cropped_blob
  end

  def cropper_blob_different?
    cropped_blob.id != active_storage_blob_id
  end


  def denormalize_website
    self.communication_website_id = about.try(:website)&.id
  end
end
