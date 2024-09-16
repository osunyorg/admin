class CreateLocalizationForCommunicationExtranetDocumentKindsAndCategories < ActiveRecord::Migration[7.1]
  def up
    create_table :communication_extranet_document_category_localizations, id: :uuid do |t|
      t.string :slug
      t.string :name

      t.references :about, foreign_key: { to_table: :communication_extranet_document_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :extranet, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
    create_table :communication_extranet_document_kind_localizations, id: :uuid do |t|
      t.string :slug
      t.string :name

      t.references :about, foreign_key: { to_table: :communication_extranet_document_kinds }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :extranet, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_extranet_document_category_localizations
    drop_table :communication_extranet_document_kind_localizations
  end
end
