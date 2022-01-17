class AddStaffStaticPathnamesToCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :static_pathname_administrators, :string, default: 'administrators'
    add_column :communication_websites, :static_pathname_researchers, :string, default: 'researchers'
    add_column :communication_websites, :static_pathname_teachers, :string, default: 'teachers'
  end
end
