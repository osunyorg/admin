class CreateCommunicationWebsitePagesCategoriesJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_table "communication_website_pages_categories", id: false, force: :cascade do |t|
      t.uuid "communication_website_page_id", null: false
      t.uuid "communication_website_page_category_id", null: false
      t.index ["communication_website_page_id", "communication_website_page_category_id"]
      t.index ["communication_website_page_category_id", "communication_website_page_id"]
    end
  end
end
