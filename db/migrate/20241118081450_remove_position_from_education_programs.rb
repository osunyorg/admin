class RemovePositionFromEducationPrograms < ActiveRecord::Migration[7.2]
  def change
    remove_column :education_programs, :position
  end
end
