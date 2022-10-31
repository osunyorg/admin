class AddFieldsToCommunicationWebsite < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :git_branch, :string
    add_column :communication_websites, :in_production, :boolean, default: false
  end
end
