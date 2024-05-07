class AddJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :communication_websites, :communication_website_showcase_tags, column_options: {type: :uuid} do |t|
      t.index [:communication_website_id, :communication_website_showcase_tag_id], name: 'index_website_showcase_tag'
      t.index [:communication_website_showcase_tag_id, :communication_website_id], name: 'index_showcase_tag_website'
    end
  end
end
