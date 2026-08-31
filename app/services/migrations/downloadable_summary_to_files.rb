class Migrations::DownloadableSummaryToFiles
  def self.migrate
    ActiveStorage::Attachment.where(
      record_type: 'Education::Program::Localization',
      name: 'downloadable_summary'
    ).find_each do |attachment|
      migrate_attachment(attachment)
    end
  end

  def self.migrate_attachment(attachment)
      program_l10n = Education::Program::Localization.find_by(id: attachment.record_id)
      return if program_l10n.nil?
      program = program_l10n.about
      language = program_l10n.language
      file_l10n = Communication::File::Localization.find_or_create_file_localization_from_blob(
        attachment.blob,
        language: language
      )
      file = file_l10n.about
      program.set_downloadable_summary!(id: file.id, language:language)
  end
end

