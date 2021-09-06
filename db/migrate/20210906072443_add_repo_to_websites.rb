class AddRepoToWebsites < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :access_token, :string
    add_column :communication_websites, :repository, :string
  end
end
