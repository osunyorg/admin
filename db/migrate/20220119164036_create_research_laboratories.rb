class CreateResearchLaboratories < ActiveRecord::Migration[6.1]
  def change
    create_table :research_laboratories, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :address
      t.string :zipcode
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
