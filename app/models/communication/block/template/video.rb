class Communication::Block::Template::Video < Communication::Block::Template::Base

  has_string :url
  has_string :video_title
  has_text :transcription

  protected

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.video.title_missing' if block.title.blank? && video_title.blank?
    accessibility_error 'accessibility.blocks.templates.video.transcription_missing' if transcription.blank?
  end
end
