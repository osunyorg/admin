class CreateServerCosts < ActiveRecord::Migration[8.1]
  def change
    create_table :server_costs, id: :uuid do |t|
      t.string :name
      t.string :description
      t.integer :annual_amount, default: 0

      t.timestamps
    end
  end
end
