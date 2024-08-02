class CreateUniversityPeopleLocalizations < ActiveRecord::Migration[7.1]
 def up
    create_table :university_person_localizations, id: :uuid do |t|
      t.string  :biography
      t.string  :first_name
      t.string  :last_name
      t.string  :linkedin
      t.string  :mastodon
      t.text    :meta_description
      t.string  :name
      t.text    :picture_credit
      t.string  :slug, index: true
      t.text    :summary
      t.string  :twitter
      t.string  :url

      t.references :about, foreign_key: { to_table: :university_people }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    University::Person.find_each do |person|
      # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
      about_id = person.original_id || person.id

      l10n = University::Person::Localization.create(
        biography: person.biography,
        first_name: person.first_name,
        last_name: person.last_name,
        linkedin: person.linkedin,
        mastodon: person.mastodon,
        meta_description: person.meta_description,
        name: person.name,
        picture_credit: person.picture_credit,
        slug: person.slug,
        summary: person.summary,
        twitter: person.twitter,
        url: person.url,
        about_id: about_id,
        language_id: person.language_id,
        university_id: person.university_id,
        created_at: person.created_at
      )

      # Copy from person (old) to localization (new)
      person.translate_contents!(l10n)
      person.translate_other_attachments(l10n)

      # Get permalinks (for aliases)
      person.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save

    end

  end

  def down
    drop_table :university_person_localizations
  end
end
