class CreateCommunicationWebsiteAgendaCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :communication_website_agenda_categories, id: :uuid do |t|
      t.string :name
      t.string :path
      t.integer :position
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :slug
      t.text :summary
      t.references :communication_website, null: false, foreign_key: { to_table: :communication_websites }, type: :uuid, index: { name: 'idx_communication_website_agenda_cats_on_website_id' }
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :original, foreign_key: {to_table: :communication_website_agenda_categories}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
