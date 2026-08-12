class CreateCommunicationExtranetInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_extranet_invitations, id: :uuid do |t|
      t.references :extranet, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :user, foreign_key: true, type: :uuid
      t.references :person, foreign_key: { to_table: :university_people }, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.string :from_name
      t.string :from_email
      t.string :to_name
      t.string :to_email
      t.text :message
      t.timestamps
    end
  end
end
