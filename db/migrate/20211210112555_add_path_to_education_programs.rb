class AddPathToEducationPrograms < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :path, :string
  end
end
