class Communication::Block::Template::Sound < Communication::Block::Template::Base

  has_component :file, :file
  has_component :title, :string
  has_component :transcription, :rich_text

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end

  def blob
    file_component.blob
  end

  def communication_file
    file_component.communication_file
  end

  def empty?
    blob.nil?
  end

  def dom_count
    5 +
    file_component.dom_count +
    title_component.dom_count +
    transcription_component.dom_count
  end

  def communication_files
    communication_file.nil? ? [] : [communication_file]
  end
  
  protected

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.sound.title_missing' if block.title.blank? && title.blank?
    accessibility_error 'accessibility.blocks.templates.sound.transcription_missing' if transcription.blank?
  end
end
