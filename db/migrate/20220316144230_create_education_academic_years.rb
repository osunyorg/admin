class CreateEducationAcademicYears < ActiveRecord::Migration[6.1]
  def change
    create_table :education_academic_years, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.integer :year

      t.timestamps
    end
  end
end
