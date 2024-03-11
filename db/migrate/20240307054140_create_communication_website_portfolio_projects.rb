class CreateCommunicationWebsitePortfolioProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :communication_website_portfolio_projects, id: :uuid do |t|
      t.string :title
      t.string :slug
      t.text :featured_image_alt
      t.text :featured_image_credit
      t.integer :year
      t.text :meta_description
      t.boolean :published, default: false
      t.text :summary
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :original, foreign_key: {to_table: :communication_website_portfolio_projects}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
