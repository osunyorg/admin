class CreateCommunicationFileCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_file_categories, id: :uuid do |t|
      t.string :bodyclass
      t.boolean :is_taxonomy, default: false
      t.integer :position, default: 0
      t.integer :position_in_tree
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :parent, foreign_key: {to_table: :communication_file_categories}, type: :uuid

      t.timestamps
    end

    create_table :communication_file_category_localizations, id: :uuid do |t|
      t.string :slug
      t.string :name
      t.text :featured_image_alt
      t.text :featured_image_credit
      t.text :summary
      t.text :meta_description

      t.references :about, foreign_key: { to_table: :communication_file_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps

      t.index [:about_id, :language_id], unique: true
    end

    create_table :communication_file_categories_files, id: false do |t|
      t.references :file, null: false, foreign_key: { to_table: :communication_files }, type: :uuid
      t.references :category, null: false, foreign_key: { to_table: :communication_file_categories }, type: :uuid
      t.index [:file_id, :category_id], name: 'file_category'
    end

  end

end
