class Migrations::FeaturedImagesToMedias
  def self.migrate
    ActiveStorage::Attachment.where(name: 'featured_image').find_each do |attachment|
      migrate_attachment(attachment)
    end
  end

  def self.migrate_attachment(attachment)
    l10n = attachment.record
    blob = attachment.blob
    return if l10n.nil? || blob.nil? || !l10n.respond_to?(:featured_media_id)

    if l10n.featured_media_id.nil?
      media = Communication::Media.find_or_create_media_from_blob(blob)
      media_l10n = media.find_or_create_localization(
        l10n.language,
        alt: l10n.featured_media_alt,
        credit: l10n.featured_image_credit
      )
      media.add_context(l10n)
      l10n.update_column(:featured_media_id, media.id)
    end

    # delete, and not destroy, to keep the blob used by the media
    attachment.delete
  end
end
