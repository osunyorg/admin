class Migrations::Medias
  def self.migrate
    Communication::Website::Page::Localization.find_each do |l10n|
      next unless l10n.featured_image.attached?
      puts "#{l10n} — #{l10n.website}"
      Communication::Media.create_from_blob l10n.featured_image.blob, 
                                            in_context: l10n, 
                                            origin: :upload, 
                                            alt: l10n.featured_image_alt,
                                            credit: l10n.featured_image_credit
    end
  end
end