class AddDeletedAtToPeopleDependencies < ActiveRecord::Migration[8.0]
  def change
    add_column :university_person_experiences, :deleted_at, :datetime
    add_column :university_person_involvements, :deleted_at, :datetime
    add_column :university_person_experience_localizations, :deleted_at, :datetime
    add_column :university_person_involvement_localizations, :deleted_at, :datetime
    add_column :university_roles, :deleted_at, :datetime
    add_column :university_role_localizations, :deleted_at, :datetime
  end
end
