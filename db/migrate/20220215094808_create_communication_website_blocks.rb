class CreateCommunicationWebsiteBlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_blocks, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :about, polymorphic: true, type: :uuid
      t.integer :template, default: 0, null: false
      t.jsonb :data
      t.integer :position, default: 0, null: false

      t.timestamps
    end
  end
end
