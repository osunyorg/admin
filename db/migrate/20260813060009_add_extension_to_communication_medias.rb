class AddExtensionToCommunicationMedias < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_medias, :original_extension, :string, default: ''
  end
end
