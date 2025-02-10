class AddUpperMenuToExtranets < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_extranets, :upper_menu, :text, default: ''
  end
end
