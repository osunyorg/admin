class RemoveSsoInheritFromUniversity < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_extranets, :sso_inherit_from_university
  end
end
