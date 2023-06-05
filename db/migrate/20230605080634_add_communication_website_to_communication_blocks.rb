class AddCommunicationWebsiteToCommunicationBlocks < ActiveRecord::Migration[7.0]
  def change
    add_reference :communication_blocks, :communication_website, foreign_key: true, type: :uuid

    Communication::Block.reset_column_information
    
    Communication::Block
      .where(about_type: "Communication::Website::Post")
      .update_all("communication_website_id = (SELECT communication_website_id FROM communication_website_posts WHERE id = about_id)")
    
    Communication::Block
      .where(about_type: "Communication::Website::Page")
      .update_all("communication_website_id = (SELECT communication_website_id FROM communication_website_pages WHERE id = about_id)")

    Communication::Block
      .where(about_type: "Communication::Website::Category")
      .update_all("communication_website_id = (SELECT communication_website_id FROM communication_website_categories WHERE id = about_id)")
  end
end
