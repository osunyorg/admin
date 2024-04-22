class AddQualiopiTextToEducationPrograms < ActiveRecord::Migration[7.1]
  def change
    rename_column :education_programs, :qualiopi, :qualiopi_certified
    add_column :education_programs, :qualiopi_text, :text
  end
end
