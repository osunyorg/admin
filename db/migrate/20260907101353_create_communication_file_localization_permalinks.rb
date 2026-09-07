class CreateCommunicationFileLocalizationPermalinks < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_file_localization_permalinks, id: :uuid do |t|
      t.string :path
      t.references :communication_file_localization, null: false, foreign_key: true, type: :uuid
      t.boolean :is_current

      t.timestamps
    end
  end
end
