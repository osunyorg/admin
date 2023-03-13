class CreateJoinTableUniversityOrganizationUniversityOrganizationCategory < ActiveRecord::Migration[7.0]
  def change
    create_table :university_organizations_categories, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: {to_table: :university_organizations}, type: :uuid
      t.references :category, null: false, foreign_key: {to_table: :university_organization_categories}, type: :uuid
    end
  end
end
