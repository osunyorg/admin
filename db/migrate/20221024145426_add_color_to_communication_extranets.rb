class AddColorToCommunicationExtranets < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_extranets, :color, :string
  end
end
