class CreateWebsiteJobboardCategoryLocalizations < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_jobboard_category_localizations, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :name
      t.string :path
      t.string :slug, index: true
      t.text :summary
      t.string :migration_identifier
      t.references :about, foreign_key: { to_table: :communication_website_jobboard_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end


