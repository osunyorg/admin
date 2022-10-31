class AddRegistrationContactToCommunicationExtranets < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_extranets, :registration_contact, :string
  end
end
