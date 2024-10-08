class CreateCommunicationWebsiteAgendaCategoryLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_agenda_categories, :language_id, true

    create_table :communication_website_agenda_category_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :name
      t.string :path
      t.string :slug, index: true
      t.text :summary

      t.references :about, foreign_key: { to_table: :communication_website_agenda_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

  end

  def down
    drop_table :communication_website_agenda_category_localizations
  end
end
