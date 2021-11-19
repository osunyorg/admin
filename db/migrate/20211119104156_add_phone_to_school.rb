class AddPhoneToSchool < ActiveRecord::Migration[6.1]
  def change
    add_column :education_schools, :phone, :string
  end
end
