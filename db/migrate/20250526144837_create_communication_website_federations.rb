class CreateCommunicationWebsiteFederations < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_federations, id: :uuid do |t|
      t.references :source_website, null: false, foreign_key: {to_table: :communication_websites}, type: :uuid
      t.references :destination_website, null: false, foreign_key: {to_table: :communication_websites}, type: :uuid
    end
  end
end
