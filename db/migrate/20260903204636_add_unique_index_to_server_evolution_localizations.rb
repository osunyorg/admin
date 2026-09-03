class AddUniqueIndexToServerEvolutionLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_index :server_evolution_localizations, [:evolution_id, :language_id], unique: true
  end
end
