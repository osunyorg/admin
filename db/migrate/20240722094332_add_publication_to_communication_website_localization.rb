class AddPublicationToCommunicationWebsiteLocalization < ActiveRecord::Migration[7.1]
  def up
    add_column :communication_website_localizations, :published, :boolean, default: false
    add_column :communication_website_localizations, :published_at, :datetime
    
    # 1. créer les locas principales
    # 2. créer les locas manquantes avec les données du website par défaut (name, socials)
    # 3. ajouter la publication aux locas existantes
    Communication::Website::Localization.reset_column_information
    Communication::Website.includes(:languages).find_each do |website|
      languages = website.languages.each do |language|
        l10n = website.localization_for(language)
        if l10n
          # Loca existante, on la publie
          l10n.update(
            published: true,
            published_at: Time.now
          )
        else
          # Loca manquante (principale ou pas), on la crée avec les données du website et on la publie
          website.localizations.create(
            university_id: website.university_id,
            language_id: language.id,
            name: website.name,
            social_email: website.social_email,
            social_facebook: website.social_facebook,
            social_github: website.social_github,
            social_instagram: website.social_instagram,
            social_linkedin: website.social_linkedin,
            social_mastodon: website.social_mastodon,
            social_peertube: website.social_peertube,
            social_tiktok: website.social_tiktok,
            social_vimeo: website.social_vimeo,
            social_x: website.social_x,
            social_youtube: website.social_youtube,
            published: true,
            published_at: Time.now
          )
        end
      end
    end
  end

  def down
    remove_column :communication_website_localizations, :published_at, :datetime
    remove_column :communication_website_localizations, :published, :boolean, default: false
  end
end
