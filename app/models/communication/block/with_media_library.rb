module Communication::Block::WithMediaLibrary
  extend ActiveSupport::Concern

  included do
    after_save :synchronize_media_library
  end

  protected
  
  def synchronize_media_library
    media_blob_ids = []
    # Add
    template.media_blobs.each do |media_blob|
      blob = media_blob[:blob]
      alt = media_blob[:alt]
      credit = media_blob[:credit]
      next if blob.nil?
      media_blob_ids << blob.id
      Communication::Media.create_from_blob(
        blob,
        in_context: self, 
        origin: :upload,
        alt: alt,
        credit: credit
      )
    end
    # Clean
    Communication::Media::Context
      .where(about: self)
      .where.not(active_storage_blob_id: media_blob_ids)
      .destroy_all
  end
end
