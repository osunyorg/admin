class AddDeliveredCountToEmergencyMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :emergency_messages, :delivered_count, :integer
  end
end
