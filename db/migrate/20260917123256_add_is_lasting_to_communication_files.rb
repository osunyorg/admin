class AddIsLastingToCommunicationFiles < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_files, :is_lasting, :boolean, default: true
  end
end
