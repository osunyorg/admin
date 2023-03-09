class Communication::Block::Template::Video < Communication::Block::Template::Base

  has_component :url, :string
  has_component :video_title, :string
  has_component :transcription, :text

  def video_iframe
    Video::Provider.find(url).iframe_tag(title: video_title)
  end

  protected

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.video.title_missing' if block.title.blank? && video_title.blank?
    accessibility_error 'accessibility.blocks.templates.video.transcription_missing' if transcription.blank?
  end
end
