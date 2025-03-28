class AddBrevoContactIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :brevo_contact_id, :integer
  end
end
