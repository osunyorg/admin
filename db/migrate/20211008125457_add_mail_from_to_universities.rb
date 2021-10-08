class AddMailFromToUniversities < ActiveRecord::Migration[6.1]
  def change
    add_column :universities, :mail_from_name, :string
    add_column :universities, :mail_from_address, :string
  end
end
