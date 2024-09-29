class CreateCommunicationWebsitePortfolioCategoryLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_portfolio_categories, :language_id, true

    create_table :communication_website_portfolio_category_localizations, id: :uuid do |t|
      t.text :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :name
      t.string :path
      t.string :published, default: false
      t.datetime :published_at
      t.string :slug
      t.text :summary

      t.references :about, foreign_key: { to_table: :communication_website_portfolio_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_website_portfolio_category_localizations
  end
end
