class AddParentToEducationFormation < ActiveRecord::Migration[6.1]
  def change
    add_reference :education_programs, :parent, foreign_key: { to_table: :education_programs }, type: :uuid
    add_column :education_programs, :position, :integer, default: 0
  end
end
