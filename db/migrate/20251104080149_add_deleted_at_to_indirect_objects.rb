class AddDeletedAtToIndirectObjects < ActiveRecord::Migration[8.0]
  def change
    add_column :education_programs, :deleted_at, :datetime
    add_column :education_program_localizations, :deleted_at, :datetime
    add_column :university_organizations, :deleted_at, :datetime
    add_column :university_organization_localizations, :deleted_at, :datetime
    add_column :university_people, :deleted_at, :datetime
    add_column :university_person_localizations, :deleted_at, :datetime
  end
end
