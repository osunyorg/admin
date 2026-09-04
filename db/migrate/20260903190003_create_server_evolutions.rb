class CreateServerEvolutions < ActiveRecord::Migration[8.1]
  def change
    create_table :server_evolutions, id: :uuid do |t|
      t.date :released_at

      t.timestamps
    end
  end
end
