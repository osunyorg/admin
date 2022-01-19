module WithBlobs
  extend ActiveSupport::Concern

  def active_storage_blobs
    explicit_active_storage_blobs.or inherited_active_storage_blobs
  end

  def explicit_active_storage_blobs
    blobs_with_ids explicit_blob_ids
  end

  def inherited_active_storage_blobs
    blobs_with_ids inherited_blob_ids
  end

  protected

  def explicit_blob_ids
    [rich_text_blob_ids]
  end

  def inherited_blob_ids
    []
  end

  def rich_text_blob_ids
    rich_text_reflection_names.map { |rich_text_reflection_name|
      rich_text = public_send(rich_text_reflection_name)
      rich_text.present? ? rich_text.embeds.blobs.pluck(:id) : []
    }.flatten
  end

  def blobs_with_ids(ids)
    university.active_storage_blobs.where(id: ids.flatten.compact)
  end

  def rich_text_reflection_names
    @rich_text_reflection_names ||= _reflections.select { |name, reflection| reflection.class_name == "ActionText::RichText" }.keys
  end
end
