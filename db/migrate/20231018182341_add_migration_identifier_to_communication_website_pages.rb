class AddMigrationIdentifierToCommunicationWebsitePages < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_website_pages, :migration_identifier, :string
  end
end
