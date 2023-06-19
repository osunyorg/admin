class CreateUserFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :user_favorites, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :about, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
