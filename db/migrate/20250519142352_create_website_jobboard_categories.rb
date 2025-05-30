class CreateWebsiteJobboardCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_jobboard_categories, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.integer :position, null: false
      t.boolean :is_programs_root, default: false
      t.boolean :is_taxonomy, default: false
      t.string :bodyclass
      t.string :migration_identifier
      t.integer :position_in_tree
      t.references :program, foreign_key: {to_table: :education_programs}, type: :uuid
      t.references :parent, foreign_key: { to_table: :communication_website_jobboard_categories }, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
