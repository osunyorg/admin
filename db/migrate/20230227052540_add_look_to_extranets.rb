class AddLookToExtranets < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_extranets, :home_sentence, :text
    add_column :communication_extranets, :sass, :text
    add_column :communication_extranets, :css, :text
  end
end
