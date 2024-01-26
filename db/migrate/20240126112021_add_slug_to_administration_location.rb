class AddSlugToAdministrationLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :administration_locations, :slug, :string
  end
end
