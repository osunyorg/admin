class AddCropSettingsToCommunicationMediaContexts < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_media_contexts, :crop_settings, :jsonb
  end
end
