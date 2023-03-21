class CreateCommunicationBlockHeadings < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_block_headings, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :about, polymorphic: true, null: false, type: :uuid
      t.string :title
      t.integer :level, default: 1
      t.references :parent, null: true, foreign_key: {to_table: :communication_block_headings}, type: :uuid
      t.integer :position
      t.string :slug

      t.timestamps
    end
    add_reference :communication_blocks, :heading, null: true, foreign_key: {to_table: :communication_block_headings}, type: :uuid
  end
end
