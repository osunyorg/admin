class RenameDomainToUrlInCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_websites, :domain, :url
  end
end
