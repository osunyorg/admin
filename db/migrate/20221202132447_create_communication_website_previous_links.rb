class CreateCommunicationWebsitePreviousLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_website_previous_links, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :website, null: false, foreign_key: { to_table: :communication_websites }, type: :uuid
      t.references :about, null: false, polymorphic: true, index: false, type: :uuid
      t.string :link

      t.timestamps
    end
  end
end
