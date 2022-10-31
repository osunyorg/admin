class RenameDomainToHostInCommunicationExtranets < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_extranets, :domain, :host
  end
end
