class CreateEducationCohorts < ActiveRecord::Migration[6.1]
  def change
    create_table :education_cohorts, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :program, null: false, foreign_key: {to_table: :education_programs}, type: :uuid
      t.references :academic_year, null: false, foreign_key: {to_table: :education_academic_years}, type: :uuid
      t.string :name

      t.timestamps
    end
  end
end
