class CreateCommunicationExtranetPostCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_extranet_post_categories, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.references :extranet, null: false, foreign_key: {to_table: :communication_extranets}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_reference :communication_extranet_posts, :category, foreign_key: {to_table: :communication_extranet_post_categories}, type: :uuid
  end
end
