class CreateCommunicationWebsitePortfolioCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :communication_website_portfolio_categories, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.text :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.boolean :is_programs_root, default: false
      t.string :path
      t.integer :position
      t.text :summary
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :original, foreign_key: {to_table: :communication_website_portfolio_categories}, type: :uuid
      t.references :parent, foreign_key: {to_table: :communication_website_portfolio_categories}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
