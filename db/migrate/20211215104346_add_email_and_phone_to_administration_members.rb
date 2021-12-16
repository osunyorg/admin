class AddEmailAndPhoneToAdministrationMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :administration_members, :phone, :string
    add_column :administration_members, :email, :string
  end
end
