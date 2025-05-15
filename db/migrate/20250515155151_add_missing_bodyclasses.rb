class AddMissingBodyclasses < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_events, :bodyclass, :string
    add_column :communication_website_agenda_exhibitions, :bodyclass, :string
    add_column :communication_website_portfolio_projects, :bodyclass, :string
    add_column :communication_website_posts, :bodyclass, :string
  end
end
