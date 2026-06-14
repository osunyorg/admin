class Communication::Block::Template::Chapter < Communication::Block::Template::Base

  has_layouts [:no_background, :alt_background, :accent_background]

  has_component :text, :rich_text
  has_component :notes, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  def media_blobs
    return [] unless image_component.blob.present?
    [
      {
        blob: image_component.blob,
        alt: alt,
        credit: credit
      }
    ]
  end

  # TODO count in components
  def dom_count
    super +
    count_dom_elements_in_html(text_component.data) +
    count_dom_elements_in_html(notes_component.data)
  end

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end
end
