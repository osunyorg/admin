class AddMetaDescriptionToFileLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_file_localizations, :meta_description, :text
  end
end
