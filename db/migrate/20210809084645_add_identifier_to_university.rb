class AddIdentifierToUniversity < ActiveRecord::Migration[6.1]
  def change
    add_column :universities, :identifier, :string
  end
end
