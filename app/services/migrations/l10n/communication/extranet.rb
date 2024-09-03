class Migrations::L10n::Communication::Extranet < Migrations::L10n::Base
  def self.execute
    migrate_extranet
  end

  def self.migrate_extranet
    Communication::Extranet.find_each do |object|
      # Les extranets ne sont pas localisés
      about_id = object.id

      l10n = Communication::Extranet::Localization.create(
        cookies_policy: object.cookies_policy,
        home_sentence: object.home_sentence,
        name: object.name,
        privacy_policy: object.privacy_policy,
        registration_contact: object.registration_contact,
        sso_button_label: object.sso_button_label,
        terms: object.terms,
        
        about_id: about_id,
        language_id: object.university.default_language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_attachment(l10n, :featured_image)

      l10n.save
    end
  end
end
