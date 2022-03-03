class CreateJoinTableCommunicationWebsitesUsers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :communication_websites, :users, column_options: {type: :uuid} do |t|
      t.index [:communication_website_id, :user_id], name: 'website_user'
      t.index [:user_id, :communication_website_id], name: 'user_website'
    end
  end
end
