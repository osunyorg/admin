class CreateCommunicationExtranetInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_extranet_invitations, id: :uuid do |t|
      t.string :email
      t.string :token
      t.datetime :sent_at
      t.datetime :accepted_at
      t.references :person, null: false, foreign_key: { to_table: :university_people }, type: :uuid
      t.references :user, foreign_key: true, type: :uuid
      t.references :creator, foreign_key: { to_table: :users }, type: :uuid
      t.references :extranet, null: false, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
