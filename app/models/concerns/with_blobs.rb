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

  def summernote_embeds
    summernote_embeds_reflection_names.map { |summernote_reflection_name|
      public_send(summernote_reflection_name)
    }.flatten
  end

  protected

  def explicit_blob_ids
    [summernote_blob_ids]
  end

  def inherited_blob_ids
    []
  end

  def summernote_blob_ids
    summernote_embeds_reflection_names.map { |summernote_reflection_name|
      public_send(summernote_reflection_name).pluck(:blob_id)
    }.flatten
  end

  def blobs_with_ids(ids)
    university.active_storage_blobs.where(id: ids.flatten.compact)
  end

  def summernote_embeds_reflection_names
    @summernote_embeds_reflection_names ||= _reflections.keys.select { |name| name.ends_with?('_summernote_embeds_attachments') }
  end
end
