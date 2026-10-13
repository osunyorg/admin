class CreateCommunicationFileRedirections < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_file_redirections, id: :uuid do |t|
      t.string :path
      t.references :communication_file_localization, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_column :communication_file_localizations, :file_server_slug, :string
    add_column :communication_file_localizations, :file_server_current_path, :string
  end
end
