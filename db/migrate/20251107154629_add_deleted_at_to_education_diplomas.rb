class AddDeletedAtToEducationDiplomas < ActiveRecord::Migration[8.0]
  def change
    add_column :education_diplomas, :deleted_at, :datetime
    add_column :education_diploma_localizations, :deleted_at, :datetime
  end
end
