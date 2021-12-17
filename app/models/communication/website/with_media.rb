module Communication::Website::WithMedia
  extend ActiveSupport::Concern

  def active_storage_blobs
    blob_ids = [best_featured_image&.blob_id, rich_text_blob_ids].flatten.compact
    university.active_storage_blobs.where(id: blob_ids)
  end

  def rich_text_reflection_names
    @rich_text_reflection_names ||= _reflections.select { |name, reflection| reflection.class_name == "ActionText::RichText" }.keys
  end

  def rich_text_blob_ids
    rich_text_reflection_names.map { |rich_text_reflection_name|
      public_send(rich_text_reflection_name).embeds.blobs.pluck(:id)
    }.flatten
  end

  # Can be overwrite to get featured_image from associated objects (ex: parents)
  def best_featured_image(fallback: true)
    featured_image
  end
end
