class CreateUniversityApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :university_apps, id: :uuid do |t|
      t.string :name
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :token

      t.timestamps
    end
  end
end
