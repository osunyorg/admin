class ConvertDurationToStringInEducationPrograms < ActiveRecord::Migration[7.1]
  def change
    change_column :education_programs, :duration, :string
  end
end
