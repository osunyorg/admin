class RemoveCommunicationExtranetPostOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_extranet_posts, :featured_image_alt
    remove_column :communication_extranet_posts, :featured_image_credit
    remove_column :communication_extranet_posts, :published
    remove_column :communication_extranet_posts, :pinned
    remove_column :communication_extranet_posts, :published_at
    remove_column :communication_extranet_posts, :slug
    remove_column :communication_extranet_posts, :summary
    remove_column :communication_extranet_posts, :title

  end
end
