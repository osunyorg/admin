class AddContentArchiveToCommunicationWebsites < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_websites, :archive_content, :boolean, default: false
    add_column :communication_websites, :years_before_archive_content, :integer, default: 3
  end
end
