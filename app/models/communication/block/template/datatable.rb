class Communication::Block::Template::Datatable < Communication::Block::Template::Base

  has_elements
  has_component :columns, :array
  has_component :caption, :text
  has_component :description, :rich_text
  has_component :alphabetical, :boolean

  def elements
    if alphabetical
      @elements.sort_by! do |element|
        "#{element.cells&.first&.to_s&.parameterize&.downcase}"
      end
    end
    @elements
  end
end
