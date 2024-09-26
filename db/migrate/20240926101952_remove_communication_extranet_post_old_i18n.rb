class RemoveCommunicationExtranetPostOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_extranet_posts, :featured_image_alt
    remove_colum :communication_extranet_posts, :featured_image_credit
    remove_colum :communication_extranet_posts, :published
    remove_colum :communication_extranet_posts, :pinned
    remove_colum :communication_extranet_posts, :published_at
    remove_colum :communication_extranet_posts, :slug
    remove_colum :communication_extranet_posts, :summary
    remove_colum :communication_extranet_posts, :title
    
  end
end
