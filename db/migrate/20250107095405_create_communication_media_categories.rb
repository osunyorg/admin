class CreateCommunicationMediaCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_media_categories, id: :uuid do |t|
      t.boolean :is_taxonomy, default: false
      t.integer :position, default: 0
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :parent, foreign_key: {to_table: :communication_media_categories}, type: :uuid

      t.timestamps
    end

    create_table :communication_media_category_localizations, id: :uuid do |t|
      t.string :slug
      t.string :name
      t.text :featured_image_alt
      t.text :featured_image_credit
      t.text :summary
      t.text :meta_description

      t.references :about, foreign_key: { to_table: :communication_media_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    create_join_table :communication_medias, :communication_media_categories, column_options: {type: :uuid} do |t|
      t.index [:communication_media_id, :communication_media_category_id], name: 'media_category'
      t.index [:communication_media_category_id, :communication_media_id], name: 'category_media'
    end
  end
end
