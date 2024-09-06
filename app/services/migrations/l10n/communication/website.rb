class Migrations::L10n::Communication::Website < Migrations::L10n::Base
  def self.execute
    # 1. créer les locas principales
    # 2. créer les locas manquantes avec les données du website par défaut (name, socials)
    # 3. ajouter la publication aux locas existantes
    Communication::Website::Localization.reset_column_information
    Communication::Website.includes(:legacy_languages).find_each do |website|
      website.legacy_languages.each do |language|
        l10n = website.localization_for(language)
        if l10n
          # Loca existante, on la publie et on gère l'ancien fallback qui prenait l'info au niveau du website
          l10n.update(
            name: l10n.name.presence || website.name,
            social_email: l10n.social_email.presence || website.social_email,
            social_facebook: l10n.social_facebook.presence || website.social_facebook,
            social_github: l10n.social_github.presence || website.social_github,
            social_instagram: l10n.social_instagram.presence || website.social_instagram,
            social_linkedin: l10n.social_linkedin.presence || website.social_linkedin,
            social_mastodon: l10n.social_mastodon.presence || website.social_mastodon,
            social_peertube: l10n.social_peertube.presence || website.social_peertube,
            social_tiktok: l10n.social_tiktok.presence || website.social_tiktok,
            social_vimeo: l10n.social_vimeo.presence || website.social_vimeo,
            social_x: l10n.social_x.presence || website.social_x,
            social_youtube: l10n.social_youtube.presence || website.social_youtube,
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
end