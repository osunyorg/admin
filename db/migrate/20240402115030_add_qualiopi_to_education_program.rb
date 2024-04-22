class AddQualiopiToEducationProgram < ActiveRecord::Migration[7.1]
  def change
    add_column :education_programs, :qualiopi, :boolean, default: false
  end
end
