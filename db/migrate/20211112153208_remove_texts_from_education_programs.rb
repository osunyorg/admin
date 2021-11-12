class RemoveTextsFromEducationPrograms < ActiveRecord::Migration[6.1]
  def change
    remove_column :education_programs, :accessibility
    remove_column :education_programs, :contacts
    remove_column :education_programs, :duration
    remove_column :education_programs, :evaluation
    remove_column :education_programs, :objectives
    remove_column :education_programs, :pedagogy
    remove_column :education_programs, :prerequisites
    remove_column :education_programs, :pricing
    remove_column :education_programs, :registration
  end
end
