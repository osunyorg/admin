class AddAdminAlreadyCreatedToUniversities < ActiveRecord::Migration[8.0]
  def change
    add_column :universities, :admin_already_auto_promoted, :boolean, default: false
    University.reset_column_information
    University.all.each do |university|
      university.update_column(:admin_already_auto_promoted, true) if university.users.admin.any?
    end
  end
end
