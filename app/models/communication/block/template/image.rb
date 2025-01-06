class Communication::Block::Template::Image < Communication::Block::Template::Base

  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text
  has_component :text, :rich_text

  def media_blobs
    if image_component.blob.present?
      [
        {
          blob: image_component.blob,
          alt: alt,
          credit: credit
        }
      ]
    else
      []
    end
  end

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end

end
