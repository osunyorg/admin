class CreateUniversities < ActiveRecord::Migration[6.1]
  def change
    create_table :universities do |t|
      t.string :name
      t.string :address
      t.string :zipcode
      t.string :city
      t.string :country
      t.boolean :private

      t.timestamps
    end
  end
end
