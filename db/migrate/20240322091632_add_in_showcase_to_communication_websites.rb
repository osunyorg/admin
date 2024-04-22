class AddInShowcaseToCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :in_showcase, :boolean, default: true
  end
end
