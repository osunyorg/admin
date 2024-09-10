class Migrations::L10n::Research::Laboratory::Axis < Migrations::L10n::Base
  def self.execute
    Research::Laboratory::Axis.find_each do |object|
      # Les axes ne sont pas localisés du tout
      about_id = object.id

      l10n = Research::Laboratory::Axis::Localization.create(
        name: object.name,
        short_name: object.short_name,
        meta_description: object.meta_description,
        summary: object.text, # summary was a "text" attribute on axis.rb
        about_id: about_id,
        language_id: object.university.default_language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

    end
  end
end