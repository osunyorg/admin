class CreateUniversityOrganizationLocalizations < ActiveRecord::Migration[7.1]
  def change
    create_table :university_organization_localizations, id: :uuid do |t|
      t.string  :address_additional
      t.string  :address_name
      t.string  :linkedin
      t.string  :long_name
      t.string  :mastodon
      t.text    :meta_description
      t.string  :name
      t.string  :slug
      t.text    :summary
      t.text    :text
      t.string  :twitter
      t.string  :url

      t.references :about, foreign_key: { to_table: :university_organizations }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    University::Organization.find_each do |orga|
      # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
      about_id = orga.original_id || orga.id

      l10n = University::Organization::Localization.create(
        address_additional: orga.address_additional,
        address_name: orga.address_name,
        linkedin: orga.linkedin,
        long_name: orga.long_name,
        mastodon: orga.mastodon,
        meta_description: orga.meta_description,
        name: orga.name,
        summary: orga.summary,
        text: orga.text,
        twitter: orga.twitter,
        url: orga.url,
        about_id: about_id,
        language_id: orga.language_id,
        university_id: orga.university_id,
        created_at: orga.created_at
      )

      # Copy from orga (old) to localization (new)
      orga.translate_contents!(l10n)
      orga.translate_other_attachments(l10n)

      # Get permalinks (for aliases)
      orga.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save

    end

  end
end
