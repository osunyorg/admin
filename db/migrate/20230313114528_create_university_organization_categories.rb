class CreateUniversityOrganizationCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :university_organization_categories, id: :uuid do |t|
      t.string :name
      t.references :university, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end
  end
end
