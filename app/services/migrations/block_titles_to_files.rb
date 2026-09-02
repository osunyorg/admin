class Migrations::BlockTitlesToFiles

  def self.migrate
    Communication::Block.where(template_kind: [:files, :sound]).with_deleted.find_each do |block|
      return if block.language.nil?
      case block.template_kind.to_sym
      when :sound
        report_title(
          block.template.communication_file,
          block.template.title,
          block.language
        )
      when :files
        block.template.elements.each do |element|
          report_title(
            element.communication_file,
            element.title,
            block.language
          )
        end
      end
    end
  end

  protected

  # Reporte le title saisi dans le bloc sur le name de la Communication::File::Localization associée,
  # uniquement si ce name n'a jamais été changé (= il vaut encore l'original_guessed_name).
  def self.report_title(communication_file, title, language)
    return if communication_file.nil? || title.blank?
    file_l10n = communication_file.localization_for(language)
    return if file_l10n.nil?
    old_name = file_l10n.name
    file_l10n.update!(name: title)
    puts "File localization #{file_l10n.id} renamed from « #{old_name} » to « #{title} »"
  end
end
