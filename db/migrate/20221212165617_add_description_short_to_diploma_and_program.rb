class AddDescriptionShortToDiplomaAndProgram < ActiveRecord::Migration[7.0]
  def change
    add_column :education_programs, :description_short, :text
    add_column :education_diplomas, :description_short, :text
  end
end
