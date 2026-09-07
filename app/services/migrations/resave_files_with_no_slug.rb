class Migrations::ResaveFilesWithNoSlug
  def self.migrate
    Communication::File::Localization.includes(:original_blob).where(slug: nil).find_each do |file_l10n|
      file_l10n.save
    end
  end
end