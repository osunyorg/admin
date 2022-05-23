class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports, id: :uuid do |t|
      t.integer :number_of_lines
      t.jsonb :processing_errors
      t.integer :kind
      t.integer :status, default: 0
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
