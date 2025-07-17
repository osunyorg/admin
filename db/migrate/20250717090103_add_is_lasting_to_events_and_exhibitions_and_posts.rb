class AddIsLastingToEventsAndExhibitionsAndPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_events, :is_lasting, :boolean, default: false
    add_column :communication_website_agenda_exhibitions, :is_lasting, :boolean, default: false
    add_column :communication_website_posts, :is_lasting, :boolean, default: false
  end
end
