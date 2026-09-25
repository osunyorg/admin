class Communication::Block::Template::File < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  # Permet de gérer les contextes
  def communication_files
    elements.map(&:communication_file).compact_blank
  end

  def communication_file_localizations_published
    unless @communication_file_localizations_published
      @communication_file_localizations_published = []
      communication_files.each do |file|
        l10n = file.localization_for(block.language)
        next unless l10n&.published?
        @communication_file_localizations_published << l10n
      end
    end
    @communication_file_localizations_published
  end

  def empty?
    communication_file_localizations_published.none?
  end

  def dom_count
    5 +
    elements.length * 10
  end
end
