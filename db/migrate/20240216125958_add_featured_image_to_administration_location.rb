class AddFeaturedImageToAdministrationLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :administration_locations, :featured_image_alt, :text
    add_column :administration_locations, :featured_image_credit, :text
  end
end
