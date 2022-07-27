class AddRegistrationUrlToEducationProgram < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :registration_url, :string
  end
end
