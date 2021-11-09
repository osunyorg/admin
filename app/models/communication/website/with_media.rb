module Communication::Website::WithMedia
  extend ActiveSupport::Concern

  def active_storage_blobs
    blob_ids = [featured_image&.blob_id, text.embeds.blobs.pluck(:id)].flatten.compact
    university.active_storage_blobs.where(id: blob_ids)
  end

  def blob_github_path_generated(blob)
    "_media/#{blob.id[0..1]}/#{blob.id}.md"
  end

  def blob_to_jekyll(blob)
    ApplicationController.render(
      template: 'active_storage/blobs/jekyll',
      layout: false,
      assigns: { blob: blob }
    )
  end

  protected

  def publish_to_github
    super
    active_storage_blobs.each do |blob|
      blob.analyze unless blob.analyzed?
      github.publish(path: blob_github_path_generated(blob),
                    commit: "[Medium] Save ##{blob.id}",
                    data: blob_to_jekyll(blob))
    end
  end
end
