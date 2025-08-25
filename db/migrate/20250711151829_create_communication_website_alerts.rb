class CreateCommunicationWebsiteAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_alerts, id: :uuid do |t|
      t.integer :kind, default: 0, null: false
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
