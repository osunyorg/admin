class Communication::Block::Template::Datatable < Communication::Block::Template::Base

  has_elements
  has_component :alphabetical, :boolean
  has_component :caption, :string
  has_component :columns, :array
  has_component :description, :rich_text

  def elements
    if alphabetical
      @elements.sort_by! do |element|
        "#{element.cells&.first&.to_s&.parameterize&.downcase.to_s}"
      end
    end
    @elements
  end
end
