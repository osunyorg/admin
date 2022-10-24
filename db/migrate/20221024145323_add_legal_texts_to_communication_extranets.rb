class AddLegalTextsToCommunicationExtranets < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_extranets, :terms, :text
    add_column :communication_extranets, :privacy_policy, :text
    add_column :communication_extranets, :cookies_policy, :text
  end
end
