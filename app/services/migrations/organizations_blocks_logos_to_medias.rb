class Migrations::OrganizationsBlocksLogosToMedias
  def self.migrate
    Communication::Block.where(template_kind: :organizations).with_deleted.find_each do |block|
      data = block.data.dup
      something_to_migrate = false
      (data['elements'] || []).each do |element|
        next unless element.is_a?(Hash)
        # {
        #   "id" => "",
        #   "name" => "Université de Rennes",
        #   "url" => "https://www.univ-rennes.fr/",
        #   "logo" => {
        #     "id" => "<uuid>",
        #     "filename" => "Universite_de_Rennes.svg",
        #     "signed_id" => "<signed_id>"
        #   },
        #   "role" => ""
        # }
        name = element['name'].presence
        logo = element['logo']
        next unless logo.is_a?(Hash)
        blob_id = logo['id']
        next unless blob_id.present?
        # Déjà migré
        next if logo['communication_media_id']
        media = blob_to_media(block, blob_id, name)
        # Pas de blob, donc pas de média
        next if media.nil?
        something_to_migrate = true
        logo['communication_media_id'] = media.id
      end
      next unless something_to_migrate
      block.data = data
      block.save
      puts "Block #{block.id} migrated"
    end
  end

  protected

  def self.blob_to_media(block, blob_id, name)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    # Blob absent
    return if blob.nil?
    media = Communication::Media.find_or_create_media_from_blob(blob)
    media_l10n = media.find_or_create_localization(block.language, name: name)
    media.add_context(block)
    media
  end

end
