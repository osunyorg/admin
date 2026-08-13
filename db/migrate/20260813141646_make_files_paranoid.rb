class MakeFilesParanoid < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_files, :deleted_at, :datetime
    add_column :communication_file_localizations, :deleted_at, :datetime
  end
end
