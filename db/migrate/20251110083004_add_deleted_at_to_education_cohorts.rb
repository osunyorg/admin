class AddDeletedAtToEducationCohorts < ActiveRecord::Migration[8.0]
  def change
    add_column :education_cohorts, :deleted_at, :datetime
    add_column :education_cohort_localizations, :deleted_at, :datetime
  end
end
