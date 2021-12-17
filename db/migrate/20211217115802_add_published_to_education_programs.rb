class AddPublishedToEducationPrograms < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :published, :boolean, default: false
  end
end
