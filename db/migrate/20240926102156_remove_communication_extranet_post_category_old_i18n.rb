class RemoveCommunicationExtranetPostCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_extranet_post_categories, :slug
    remove_colum :communication_extranet_post_categories, :nam
  end
end
