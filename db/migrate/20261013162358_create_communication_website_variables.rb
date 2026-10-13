class CreateCommunicationWebsiteVariables < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_website_variables, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.integer :key
      t.string :value

      t.timestamps
    end
  end
end
