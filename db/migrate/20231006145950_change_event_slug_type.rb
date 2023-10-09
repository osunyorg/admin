class ChangeEventSlugType < ActiveRecord::Migration[7.0]
  def change
    change_column :communication_website_agenda_events, :slug, :string
    change_column :communication_website_posts, :slug, :string
  end
end
