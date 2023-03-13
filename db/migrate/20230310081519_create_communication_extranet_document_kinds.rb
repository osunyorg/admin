class CreateCommunicationExtranetDocumentKinds < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_extranet_document_kinds, id: :uuid do |t|
      t.references :extranet, null: false, foreign_key: {to_table: :communication_extranets}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid, index: { name: 'extranet_document_kinds_universities' }
      t.string :name

      t.timestamps
    end

    add_reference :communication_extranet_documents, :kind, foreign_key: {to_table: :communication_extranet_document_kinds}, type: :uuid, index: { name: 'index_extranet_document_kinds' }
  end
end
