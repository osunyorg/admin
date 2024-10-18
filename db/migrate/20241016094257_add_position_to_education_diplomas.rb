class AddPositionToEducationDiplomas < ActiveRecord::Migration[7.1]
  def change
    add_column :education_diplomas, :position, :integer, default: 0
  end
end
