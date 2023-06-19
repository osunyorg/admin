class Communication::Block::Template::Sound < Communication::Block::Template::Base

  has_component :file, :file
  has_component :title, :string
  has_component :transcription, :text

  protected

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.sound.title_missing' if block.title.blank? && title.blank?
    accessibility_error 'accessibility.blocks.templates.sound.transcription_missing' if transcription.blank?
  end
end
