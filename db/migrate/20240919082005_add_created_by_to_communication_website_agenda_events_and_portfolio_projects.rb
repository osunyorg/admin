class AddCreatedByToCommunicationWebsiteAgendaEventsAndPortfolioProjects < ActiveRecord::Migration[7.1]
  def change
    add_reference :communication_website_agenda_events, :created_by, foreign_key: { to_table: :users }, type: :uuid
    add_reference :communication_website_portfolio_projects, :created_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
