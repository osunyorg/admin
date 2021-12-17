class AddDescriptionToEducationPrograms < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :description, :text
  end
end
