class Communication::Block::Template::Gallery < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :carousel, :large]
  has_component :description, :rich_text

  def empty?
    elements.none?
  end

  def media_blobs
    return [] if empty?
    elements.map(&:media_blob).compact
  end
end
