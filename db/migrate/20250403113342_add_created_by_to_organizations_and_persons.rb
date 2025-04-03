class AddCreatedByToOrganizationsAndPersons < ActiveRecord::Migration[8.0]
  def change
    add_reference :university_organizations, :created_by, foreign_key: { to_table: :users }, type: :uuid
    add_reference :university_people, :created_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
