module Communication::Website::Imported::WithFeaturedImage
  extend ActiveSupport::Concern

  protected

  def download_featured_medium_file_as_featured_image(object)
    featured_medium.load_remote_file! unless featured_medium.file.attached?
    object.featured_image.attach(
      io: URI.open(featured_medium.file.blob.url),
      filename: featured_medium.file.blob.filename,
      content_type: featured_medium.file.blob.content_type
    )
  end

  def download_first_image_in_text_as_featured_image(object)
    fragment = Nokogiri::HTML.fragment(object.text.to_s)
    image = fragment.css('img').first
    return unless image.present?
    begin
      url = image.attr('src')
      download_service = DownloadService.download(url)
      object.featured_image.attach(download_service.attachable_data)
      image.remove
      object.update(text: fragment.to_html)
    rescue
    end
  end
end
