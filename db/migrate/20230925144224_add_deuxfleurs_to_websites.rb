class AddDeuxfleursToWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :deuxfleurs_hosting, :boolean, default: false
    add_column :communication_websites, :deuxfleurs_id, :string
  end
end
