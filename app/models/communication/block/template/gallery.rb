class Communication::Block::Template::Gallery < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :carousel, :large]
  has_component :description, :rich_text

  def empty?
    media_blobs.none?
  end

  def media_blobs
    return [] if elements.none?
    elements.map(&:media_blob).compact
  end
end
