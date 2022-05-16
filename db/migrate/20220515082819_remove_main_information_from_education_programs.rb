class RemoveMainInformationFromEducationPrograms < ActiveRecord::Migration[6.1]
  def change
    remove_column :education_programs, :main_information
  end
end
