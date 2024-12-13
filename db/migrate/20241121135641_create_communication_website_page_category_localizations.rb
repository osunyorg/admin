class CreateCommunicationWebsitePageCategoryLocalizations < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_page_category_localizations, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.string :path
      t.text :meta_description
      t.text :summary
      t.text :featured_image_alt
      t.text :featured_image_credit

      t.references :about, foreign_key: { to_table: :communication_website_page_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
