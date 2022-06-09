class AddTrainingInfosToProgram < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :initial, :boolean
    add_column :education_programs, :apprenticeship, :boolean
  end
end
