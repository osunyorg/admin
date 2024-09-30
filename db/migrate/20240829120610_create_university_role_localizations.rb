class CreateUniversityRoleLocalizations < ActiveRecord::Migration[7.1]
  def change
    create_table :university_role_localizations, id: :uuid do |t|
      t.text :description

      t.references :about, foreign_key: { to_table: :university_roles }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
