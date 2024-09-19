module User::WithAuthorship
  extend ActiveSupport::Concern

  included do
    has_many  :research_journal_papers,
              class_name: "Research::Journal::Paper",
              foreign_key: :updated_by_id,
              dependent: :nullify
    has_many  :communication_website_agenda_events,
              class_name: "Communication::Website::Agenda::Event",
              foreign_key: :created_by_id,
              dependent: :nullify
    has_many  :communication_website_portfolio_projects,
              class_name: "Communication::Website::Portfolio::Project",
              foreign_key: :created_by_id,
              dependent: :nullify
  end
end
