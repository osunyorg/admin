class Communication::Block::Template::Video < Communication::Block::Template::Base

  has_component :description, :rich_text
  has_component :url, :string
  has_component :video_title, :string
  has_component :transcription, :rich_text

  def video_iframe
    video_provider.iframe_tag(title: video_iframe_title)
  end

  def video_iframe_title
    video_title.blank?  ? 'Video'
                        : video_title
  end

  def video_platform
    video_provider.platform
  end

  def video_identifier
    video_provider.identifier
  end

  def video_poster
    video_provider.poster
  end

  def video_embed
    video_provider.embed
  end

  def video_embed_with_defaults
    video_provider.embed_with_defaults
  end

  protected

  def video_provider
    @video_provider ||= Video::Provider.find(url)
  end

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.video.title_missing' if block.title.blank? && video_title.blank?
    accessibility_error 'accessibility.blocks.templates.video.transcription_missing' if transcription.blank?
  end
end
