class FixSiret < ActiveRecord::Migration[6.1]
  def change
    add_column :university_organizations, :nic, :string
  end
end
