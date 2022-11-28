class RemoveLevelFromEducationPrograms < ActiveRecord::Migration[7.0]
  def change
    remove_column :education_programs, :level, :integer
  end
end
