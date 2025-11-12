class AddDeletedAtToEducationSchools < ActiveRecord::Migration[8.0]
  def change
    add_column :education_schools, :deleted_at, :datetime
    add_column :education_school_localizations, :deleted_at, :datetime
  end
end
