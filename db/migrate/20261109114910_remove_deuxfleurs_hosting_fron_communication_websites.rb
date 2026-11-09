class RemoveDeuxfleursHostingFronCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    remove_column :communication_websites, :deuxfleurs_hosting, :boolean, default: true
  end
end
