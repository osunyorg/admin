class AddPublicationToCommunicationWebsiteLocalization < ActiveRecord::Migration[7.1]
  def up
    # We moved the migration date to make sure this one is up before creating localizations tables.
    # To prevent this to get executed twice, we check the column existence first.
    return if connection.column_exists?(:communication_website_localizations, :published)

    add_column :communication_website_localizations, :published, :boolean, default: false
    add_column :communication_website_localizations, :published_at, :datetime

  end

  def down
    remove_column :communication_website_localizations, :published_at, :datetime
    remove_column :communication_website_localizations, :published, :boolean, default: false
  end
end
