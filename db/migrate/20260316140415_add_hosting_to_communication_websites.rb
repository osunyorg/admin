class AddHostingToCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_websites, :hosting, :integer, default: 1, null: false
    Communication::Website.reset_column_information
    Communication::Website.where(deuxfleurs_hosting: false).update_all(hosting: :undefined)
  end
end
