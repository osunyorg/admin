class AddPresentationToEducationProgram < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :presentation, :text
  end
end
