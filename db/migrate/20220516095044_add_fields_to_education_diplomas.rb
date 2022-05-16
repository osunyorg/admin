class AddFieldsToEducationDiplomas < ActiveRecord::Migration[6.1]
  def change
    add_column :education_diplomas, :ects, :integer
    add_column :education_diplomas, :duration, :text
    remove_column :education_programs, :ects
  end
end
