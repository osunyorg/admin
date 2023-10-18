class Communication::Block::Template::Person < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text
  has_component :with_link, :boolean
  has_component :with_photo, :boolean
  has_component :alphabetical, :boolean

  def elements
    if alphabetical
      @elements.sort_by! do |element|
        "#{element.person&.last_name&.parameterize&.downcase}"
      end
    end
    @elements
  end
end
