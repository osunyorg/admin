class DeuxfleursByDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :communication_websites, :deuxfleurs_hosting, :boolean, default: true

  end
end
