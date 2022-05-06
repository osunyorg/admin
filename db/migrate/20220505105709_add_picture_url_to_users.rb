class AddPictureUrlToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :picture_url, :string
  end
end
