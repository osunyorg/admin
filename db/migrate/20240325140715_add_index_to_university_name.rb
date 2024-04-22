class AddIndexToUniversityName < ActiveRecord::Migration[7.1]
  def change
    add_index :universities, :name, opclass: :gin_trgm_ops, using: :gin
    add_index :communication_websites, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
