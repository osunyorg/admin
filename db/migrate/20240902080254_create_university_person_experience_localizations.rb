class CreateUniversityPersonExperienceLocalizations < ActiveRecord::Migration[7.1]
  def change
    create_table :university_person_experience_localizations, id: :uuid do |t|
      t.string :description
      t.references :about, foreign_key: { to_table: :university_person_experiences }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
