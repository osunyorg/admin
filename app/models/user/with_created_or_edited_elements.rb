module User::WithCreatedOrEditedElements
  extend ActiveSupport::Concern

  included do

    # Créations

    has_many :created_communication_files,
             class_name: "Communication::File",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_communication_medias,
             class_name: "Communication::Media",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_communication_website_agenda_events,
             class_name: "Communication::Website::Agenda::Event",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_communication_website_agenda_exhibitions,
             class_name: "Communication::Website::Agenda::Exhibition",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_communication_website_jobboard_jobs,
             class_name: "Communication::Website::Jobboard::Job",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_communication_website_portfolio_projects,
             class_name: "Communication::Website::Portfolio::Project",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_university_organizations,
             class_name: "University::Organization",
             foreign_key: "created_by_id",
             dependent: :nullify

    has_many :created_university_people,
             class_name: "University::Person",
             foreign_key: "created_by_id",
             dependent: :nullify

    # Mises à jour

    has_many  :updated_communication_file_localizations,
              class_name: "Communication::File::Localization",
              foreign_key: :updated_by_id,
              dependent: :nullify

    has_many  :updated_communication_media_localizations,
              class_name: "Communication::Media::Localization",
              foreign_key: :updated_by_id,
              dependent: :nullify

    has_many  :updated_research_journal_papers,
              class_name: "Research::Journal::Paper",
              foreign_key: :updated_by_id,
              dependent: :nullify
  end
end
