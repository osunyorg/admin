class Migrations::BlocksWithMedias

  TEMPLATES = [
    :chapter,
    :image,
    :call_to_action
  ]

  TEMPLATES_WITH_ELEMENTS = [
    :features,
    :gallery,
    :key_figures,
    :links
  ]

  def self.migrate
    TEMPLATES.each do |template_kind|
      Communication::Block.where(template_kind: template_kind).with_deleted.find_each do |block|
        data = block.data.dup
        image = data['image']
        next unless image.is_a?(Hash)
        blob_id = image['id']
        next unless blob_id.present?
        # Déjà migré
        next if image['communication_media_id']
        media = blob_to_media(block, blob_id, data.dig('alt'), data.dig('credit'))
        # Pas de blob, donc pas de média
        next if media.nil?
        image['communication_media_id'] = media.id
        block.data = data
        block.save
        puts "Block #{block.id} migrated"
      end
    end
    TEMPLATES_WITH_ELEMENTS.each do |template_kind|
      Communication::Block.where(template_kind: template_kind).with_deleted.find_each do |block|
        data = block.data.dup
        something_to_migrate = false
        (data['elements'] || []).each do |element|
          next unless element.is_a?(Hash)
          image = element['image']
          next unless image.is_a?(Hash)
          blob_id = image['id']
          next unless blob_id.present?
          # Déjà migré
          next if image['communication_media_id']
          media = blob_to_media(block, blob_id, element.dig('alt'), element.dig('credit'))
          # Pas de blob, donc pas de média
          next if media.nil?
          something_to_migrate = true
          image['communication_media_id'] = media.id
        end
        next unless something_to_migrate
        block.data = data
        block.save
        puts "Block #{block.id} migrated"
      end
    end
  end

  protected

  def self.blob_to_media(block, blob_id, alt, credit)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    # Blob absent
    return if blob.nil?
    media = Communication::Media.find_or_create_media_from_blob(blob)
    media_l10n = media.find_or_create_localization(block.language, alt: alt, credit: credit)
    media.add_context(block)
    media
  end

end
