class Communication::Block::Template::Embed < Communication::Block::Template::Base

  has_component :code, :text
  has_component :iframe_title, :string
  has_component :transcription, :text

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.embed.title_missing' if  iframe_title.blank?
    accessibility_error 'accessibility.blocks.templates.embed.transcription_missing' if transcription.blank?
  end

end
