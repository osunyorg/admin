class RenameCategoriesJoinTables < ActiveRecord::Migration[7.2]
  def change
    rename_table :communication_website_pages_categories, :communication_website_page_categories_pages
    rename_table :communication_website_categories_posts, :communication_website_post_categories_posts
    rename_table :communication_website_agenda_events_categories, :communication_website_agenda_categories_events
    rename_table :university_people_categories, :university_people_person_categories
    rename_table :university_organizations_categories, :university_organization_categories_organizations
  end
end
