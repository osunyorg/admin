module User::WithCreatedElements
  extend ActiveSupport::Concern

  included do
    has_many :created_university_people,
             class_name: "University::Person",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_university_organizations,
             class_name: "University::Organization",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_agenda_events,
              class_name: "Communication::Website::Agenda::Event",
              foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_agenda_exhibitions,
              class_name: "Communication::Website::Agenda::Exhibition",
              foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_jobboard_jobs,
              class_name: "Communication::Website::Jobboard::Job",
              foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_portfolio_projects,
              class_name: "Communication::Website::Portfolio::Project",
              foreign_key: "created_by_id",
             dependent: :nullify
  end
end
