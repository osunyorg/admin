class FixSiret < ActiveRecord::Migration[6.1]
  def change
    rename_column :university_organizations, :sirene, :siren
    add_column :university_organizations, :nic, :string
  end
end
