class AddInternalDescriptionToCommunicationMediaLocalizations < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_media_localizations, :internal_description, :text
  end
end
