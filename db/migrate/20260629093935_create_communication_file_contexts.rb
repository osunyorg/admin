class CreateCommunicationFileContexts < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_file_contexts, id: :uuid do |t|
      t.references :about, polymorphic: true, type: :uuid
      t.references :communication_file_localization, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
