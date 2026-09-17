class CreateServerEvolutionLocalizations < ActiveRecord::Migration[8.1]
  def change
    create_table :server_evolution_localizations, id: :uuid do |t|
      t.references :evolution, null: false, foreign_key: { to_table: :server_evolutions }, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
