class AddChosenNameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :chosen_name, :string
  end
end
