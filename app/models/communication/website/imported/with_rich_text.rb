module Communication::Website::Imported::WithRichText
  extend ActiveSupport::Concern

  protected

  def rich_text_with_attachments(text)
    fragment = Nokogiri::HTML.fragment(text)
    images = fragment.css("img[src*=\"#{website.website.domain_url}\"]")
    images.each do |image|
      begin
        url = image.attr('src')
        blob = load_blob_from_url(url)
        image.replace ActionText::Attachment.from_attachable(blob).node.to_s
      rescue
      end
    end
    fragment.to_html
  end

  def load_blob_from_url(url)
    medium = website.media.for_variant_url(url).first
    if medium.present?
      medium.load_remote_file! unless medium.file.attached?
      # Currently a copy, should we link the medium blob instead?
      blob = medium.file.blob.open do |tempfile|
        ActiveStorage::Blob.create_and_upload!(
          io: tempfile,
          filename: medium.file.blob.filename,
          content_type: medium.file.blob.content_type
        )
      end
    else
      download_service = DownloadService.download(url)
      blob = ActiveStorage::Blob.create_and_upload!(download_service.attachable_data)
    end
    blob.update_column(:university_id, self.university_id)
    blob.analyze_later
    blob
  end
end
