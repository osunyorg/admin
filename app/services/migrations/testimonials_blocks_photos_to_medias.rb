class Migrations::TestimonialsBlocksPhotosToMedias
  def self.migrate
    Communication::Block.where(template_kind: :testimonial).with_deleted.find_each do |block|
      data = block.data.dup
      something_to_migrate = false
      (data['elements'] || []).each do |element|
        next unless element.is_a?(Hash)
        # {
        #   "text" => "<p>...</p>",
        #   "author" => "Prénom Nom",
        #   "job" => "Rôle",
        #   "photo" => {
        #     "id" => "<uuid>",
        #     "filename" => "1732791055365.jpg",
        #     "signed_id" => "<signed_id>"
        #   }
        # }
        author = element['author'].presence
        photo = element['photo']
        next unless photo.is_a?(Hash)
        blob_id = photo['id']
        next unless blob_id.present?
        # Déjà migré
        next if element.dig('photo', 'communication_media_id')
        media = blob_to_media(block, blob_id, author)
        # Pas de blob, donc pas de média
        next if media.nil?
        something_to_migrate = true
        element['photo']['communication_media_id'] = media.id
      end
      next unless something_to_migrate
      block.data = data
      block.save
      puts "Block #{block.id} migrated"
    end
  end

  protected

  def self.blob_to_media(block, blob_id, author)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    # Blob absent
    return if blob.nil?
    media = Communication::Media.find_or_create_media_from_blob(blob)
    media_l10n = media.find_or_create_localization(block.language, name: author)
    media.add_context(block)
    media
  end

end
