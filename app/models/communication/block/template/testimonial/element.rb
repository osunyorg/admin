class Communication::Block::Template::Testimonial::Element < Communication::Block::Template::Base

  has_component :text, :rich_text
  has_component :author, :string
  has_component :job, :string
  has_component :photo, :image

  def empty?
    text.blank?
  end

  def blob
    photo_component.blob
  end

  def communication_media
    photo_component.communication_media
  end

  def communication_media_l10n
    communication_media.localization_for(block.language)
  end

  def dom_count
    2 +
    text_component.dom_count +
    author_component.dom_count +
    job_component.dom_count +
    photo_component.dom_count
  end
end
