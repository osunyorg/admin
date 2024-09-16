class CreateCommunicationWebsitePortfolioProjectLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_portfolio_projects, :language_id, true

    create_table :communication_website_portfolio_project_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.text :summary
      t.string :title

      t.references :about, foreign_key: { to_table: :communication_website_portfolio_projects }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_website_portfolio_project_localizations
  end
end
