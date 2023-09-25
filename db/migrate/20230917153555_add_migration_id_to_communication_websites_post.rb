class AddMigrationIdToCommunicationWebsitesPost < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_website_posts, :migration_identifier, :string
  end
end
