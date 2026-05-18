class AddUseDxflRedirectsToWebsites < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_websites, :deuxfleurs_use_dxfl_redirects, :boolean, default: false, null: false
  end
end
