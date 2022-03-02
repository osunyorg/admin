class CreateCommunicationExtranets < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_extranets, id: :uuid do |t|
      t.string :name
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :domain

      t.timestamps
    end
  end
end
