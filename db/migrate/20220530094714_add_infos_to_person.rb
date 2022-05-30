class AddInfosToPerson < ActiveRecord::Migration[6.1]
  def change
    add_column :university_people, :gender, :integer
    add_column :university_people, :birthdate, :date
    rename_column :university_people, :phone, :phone_mobile
    add_column :university_people, :phone_professional, :string
    add_column :university_people, :phone_personal, :string
    add_column :university_people, :address, :string
    add_column :university_people, :zipcode, :string
    add_column :university_people, :city, :string
    add_column :university_people, :country, :string
  end
end
