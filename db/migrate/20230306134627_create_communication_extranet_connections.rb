class CreateCommunicationExtranetConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_extranet_connections, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :extranet, null: false, foreign_key: {to_table: :communication_extranets}, type: :uuid
      t.references :object, type: :uuid, polymorphic: true

      t.timestamps
    end
  end
end
