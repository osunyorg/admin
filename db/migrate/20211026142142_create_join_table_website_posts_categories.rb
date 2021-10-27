class CreateJoinTableWebsitePostsCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :communication_website_posts, :communication_website_categories, column_options: {type: :uuid} do |t|
      t.index [:communication_website_post_id, :communication_website_category_id], name: 'post_category'
      t.index [:communication_website_category_id, :communication_website_post_id], name: 'category_post'
    end
  end
end
