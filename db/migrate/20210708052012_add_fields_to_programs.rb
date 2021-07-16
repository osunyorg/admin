class AddFieldsToPrograms < ActiveRecord::Migration[6.1]
  def change
    add_column :programs, :pricing, :text
    add_column :programs, :contacts, :text
  end
end
