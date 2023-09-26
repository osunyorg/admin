class ChangeIdToIdentifier < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_websites, :deuxfleurs_id, :deuxfleurs_identifier
  end
end
