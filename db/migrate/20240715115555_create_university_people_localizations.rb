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
  end

  def down
    drop_table :university_person_localizations
  end
end
