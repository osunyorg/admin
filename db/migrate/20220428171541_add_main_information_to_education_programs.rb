class AddMainInformationToEducationPrograms < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :main_information, :text
  end
end
