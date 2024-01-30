class AddPhotoCreditsToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :university_people, :picture_credit, :text
  end
end
