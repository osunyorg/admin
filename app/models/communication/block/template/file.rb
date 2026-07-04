class Communication::Block::Template::File < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  def communication_files
    unless @communication_files
      @communication_files = []
      elements.each do |element|
        next if element.communication_file.nil?
        @communication_files << element.communication_file
      end
    end
    @communication_files
  end
end
