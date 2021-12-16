module Communication::Website::Imported::WithRichText
  extend ActiveSupport::Concern

  # https://github.com/basecamp/trix/blob/7940a9a3b7129f8190ef37e086809260d7ccfe32/src/trix/models/attachment.coffee#L4
  TRIX_PREVIEWABLE_PATTERN = /^image(\/(gif|png|jpe?g)|$)/

  protected

  def rich_text_with_attachments(text)
    fragment = Nokogiri::HTML.fragment(text)
    fragment = replace_tags_with_attachments(fragment, 'a', 'href')
    fragment = replace_tags_with_attachments(fragment, 'img', 'src')
    fragment.to_html
  end

  def replace_tags_with_attachments(fragment, tag_name, attribute_name)
    nodes = fragment.css("#{tag_name}[#{attribute_name}*=\"#{website.uploads_url}\"]")
    nodes.each do |node|
      begin
        url = node.attr(attribute_name)
        blob = load_blob_from_url(url)
        blob.analyze
        blob_path = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
        attachment_node = ActionText::Attachment.from_attachable(blob).node
        attachment_node['url'] = "#{university.url}#{blob_path}"
        attachment_node['width'] = blob.metadata['width']
        attachment_node['height'] = blob.metadata['height']
        attachment_node['presentation'] = TRIX_PREVIEWABLE_PATTERN.match?(blob.content_type) ? 'gallery' : nil
        node.replace attachment_node.to_s
      rescue
      end
    end
    fragment
  end

  def load_blob_from_url(url)
    medium = website.media.for_variant_url(url).first
    if medium.present?
      unless medium.file.attached?
        medium.load_remote_file!
        medium.save
      end
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
