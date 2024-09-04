class CreateCommunicationExtranetDocumentLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :communication_extranet_document_localizations, id: :uuid do |t|
      t.string :name
      t.boolean :published, default: false
      t.datetime :published_at

      t.references :about, foreign_key: { to_table: :communication_extranet_documents }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :extranet, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_extranet_document_localizations
  end
end
