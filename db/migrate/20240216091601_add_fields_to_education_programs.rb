class AddFieldsToEducationPrograms < ActiveRecord::Migration[7.1]
  def change
    add_column :education_programs, :bodyclass, :string
    add_column :education_programs, :url, :string
  end
end
