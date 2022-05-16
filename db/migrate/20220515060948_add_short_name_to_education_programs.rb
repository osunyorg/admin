class AddShortNameToEducationPrograms < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :short_name, :string
  end
end
