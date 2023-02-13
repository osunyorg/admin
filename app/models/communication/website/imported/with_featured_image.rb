module Communication::Website::Imported::WithFeaturedImage
  extend ActiveSupport::Concern

  included do
    after_commit :sync_featured_image, on: [:create, :update]
  end

  def sync_featured_image
    return unless ENV['APPLICATION_ENV'] == 'development' || updated_at > generated_object.updated_at

    if featured_medium.present?
      sync_featured_image_from_featured_medium
    else
      sync_featured_image_from_content
    end
  end

  def sync_featured_image_from_featured_medium
    unless featured_medium.file.attached?
      featured_medium.load_remote_file!
      featured_medium.save
    end
    generated_object.featured_image.attach(
      io: URI.open(featured_medium.file.blob.url),
      filename: featured_medium.file.blob.filename,
      content_type: featured_medium.file.blob.content_type
    )
  end

  def sync_featured_image_from_content
    chapter = generated_object.blocks.where(university: website.university, template_kind: :chapter).first_or_create
    chapter_data = chapter.data.deep_dup
    fragment = Nokogiri::HTML.fragment(chapter_data['text'].to_s)
    image = fragment.css('img').first
    if image.present?
      begin
        url = image.attr('src')
        download_service = DownloadService.download(url)
        generated_object.featured_image.attach(download_service.attachable_data)
        image.remove
        chapter_data['text'] = fragment.to_html
        chapter.data = chapter_data
        chapter.save
      rescue
      end
    end
  end
end