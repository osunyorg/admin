class RemoveDeuxfleursUseDxflRedirectsFromCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    remove_column :communication_websites, :deuxfleurs_use_dxfl_redirects, :boolean, default: false, null: false
  end
end
