class CreateEducationCohortLocalizations < ActiveRecord::Migration[8.0]
  def change
    create_table :education_cohort_localizations, id: :uuid do |t|
      t.references :about, null: false, foreign_key: {to_table: :education_cohorts}, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :slug

      t.timestamps
    end
  end
end
