class RemoveAdministrationLocationOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :administration_locations, :original_id
    remove_column :administration_locations, :language_id
    remove_column :administration_locations, :address_additional
    remove_column :administration_locations, :address_name
    remove_column :administration_locations, :featured_image_alt
    remove_column :administration_locations, :featured_image_credit
    remove_column :administration_locations, :slug
    remove_column :administration_locations, :summary
    remove_column :administration_locations, :name
    remove_column :administration_locations, :url
  end
end
