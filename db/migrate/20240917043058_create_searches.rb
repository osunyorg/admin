class CreateSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :search, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.text :text
      t.references :language, null: false, type: :uuid
      t.references :about_object, polymorphic: true, null: false, type: :uuid
      t.references :about_localization, polymorphic: true, null: false, type: :uuid
      t.references :website, foreign_key: {to_table: :communication_websites}, type: :uuid
      t.references :extranet, foreign_key: {to_table: :communication_extranets}, type: :uuid

      t.timestamps
    end
  end
end
