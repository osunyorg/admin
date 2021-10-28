class CreateCommunicationWebsiteAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_authors, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :user, foreign_key: true, type: :uuid
      t.references :communication_website,
                  null: false,
                  foreign_key: { to_table: :communication_websites },
                  type: :uuid,
                  index: { name: 'idx_comm_website_authors_on_communication_website_id' }
      t.string :last_name
      t.string :first_name
      t.string :slug
      t.timestamps
    end
  end
end
