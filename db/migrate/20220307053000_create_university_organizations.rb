class CreateUniversityOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :university_organizations, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :long_name
      t.text :description
      t.string :address
      t.string :zipcode
      t.string :city
      t.string :country
      t.string :website
      t.string :phone
      t.string :mail
      t.boolean :active, default: true
      t.string :siren
      t.integer :kind, default: 10

      t.timestamps
    end
  end
end
