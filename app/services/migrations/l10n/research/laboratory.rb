class Migrations::L10n::Research::Laboratory < Migrations::L10n::Base
  def self.execute
    Research::Laboratory.find_each do |object|
      # Les labs ne sont pas localisés du tout
      about_id = object.id

      l10n = Research::Laboratory::Localization.create(
        address_additional: object.address_additional,
        address_name: object.address_name,
        name: object.name,
        about_id: about_id,
        language_id: object.university.default_language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      l10n.save
    end
  end
end