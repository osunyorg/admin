class CreateCommunicationExtranetFiles < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_extranets, :feature_assets, :feature_files

    create_table :communication_extranet_files, id: :uuid do |t|
      t.string :name
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :extranet, null: false, foreign_key: {to_table: :communication_extranets}, type: :uuid
      t.boolean :published
      t.datetime :published_at

      t.timestamps
    end
  end
end
