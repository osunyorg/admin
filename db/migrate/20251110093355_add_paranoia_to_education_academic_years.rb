class AddParanoiaToEducationAcademicYears < ActiveRecord::Migration[8.0]
  def change
    add_column :education_academic_years, :deleted_at, :datetime
    add_column :education_academic_year_localizations, :deleted_at, :datetime

  end
end
