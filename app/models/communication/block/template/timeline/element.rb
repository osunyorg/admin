class Communication::Block::Template::Timeline::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :text, :rich_text

  def empty?
   title.blank? && text.blank?
  end

  def dom_count
    2 +
    title_component.dom_count +
    text_component.dom_count
  end
end
