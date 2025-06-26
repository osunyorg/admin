class AddBodyclassToPersonsAndOrganizations < ActiveRecord::Migration[8.0]
  def change
    add_column :university_people, :bodyclass, :string
    add_column :university_organizations, :bodyclass, :string
  end
end
