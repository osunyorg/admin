class AddPositionToOrgsAndPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :university_person_categories, :position, :integer, default: 0
    add_column :university_organization_categories, :position, :integer, default: 0
  end
end
