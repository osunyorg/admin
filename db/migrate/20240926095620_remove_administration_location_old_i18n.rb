class RemoveAdministrationLocationOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :administration_locations, :original_id
    remove_colum :administration_locations, :language_id
    remove_colum :administration_locations, :address_additional
    remove_colum :administration_locations, :address_name
    remove_colum :administration_locations, :featured_image_alt
    remove_colum :administration_locations, :featured_image_credit
    remove_colum :administration_locations, :slug
    remove_colum :administration_locations, :summary
    remove_colum :administration_locations, :name
    remove_colum :administration_locations, :url
  end
end
