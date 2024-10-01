class AddCertificationToEducationDiploma < ActiveRecord::Migration[7.1]
  def change
    add_column :education_diplomas, :certification, :string
  end
end
