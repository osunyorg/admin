class TrulyDestroySoftDeletedRecordsJob < ApplicationJob
  queue_as :default

  PARANOID_MODELS = [
    ActiveStorage::Attachment,
    Administration::Location,
    Administration::Location::Localization,
    Communication::Block,
    Communication::Website::Alert,
    Communication::Website::Page,
    Communication::Website::Post,
    Communication::Website::Agenda::Event,
    Communication::Website::Agenda::Exhibition,
    Communication::Website::Agenda::Event::Localization,
    Communication::Website::Agenda::Event::TimeSlot,
    Communication::Website::Agenda::Event::TimeSlot::Localization,
    Communication::Website::Agenda::Exhibition::Localization,
    Communication::Website::Alert::Localization,
    Communication::Website::Jobboard::Job,
    Communication::Website::Jobboard::Job::Localization,
    Communication::Website::Page::Localization,
    Communication::Website::Portfolio::Project,
    Communication::Website::Portfolio::Project::Localization,
    Communication::Website::Post::Localization,
    Education::AcademicYear,
    Education::Cohort,
    Education::Diploma,
    Education::Program,
    Education::School,
    Education::AcademicYear::Localization,
    Education::Cohort::Localization,
    Education::Diploma::Localization,
    Education::Program::Localization,
    Education::School::Localization,
    Research::Journal,
    Research::Laboratory,
    Research::Thesis,
    Research::Journal::Localization,
    Research::Journal::Paper,
    Research::Journal::Volume,
    Research::Journal::Paper::Kind,
    Research::Journal::Paper::Localization,
    Research::Journal::Paper::Kind::Localization,
    Research::Journal::Volume::Localization,
    Research::Laboratory::Axis,
    Research::Laboratory::Localization,
    Research::Laboratory::Axis::Localization,
    Research::Thesis::Localization,
    University::Organization,
    University::Person,
    University::Role,
    University::Organization::Localization,
    University::Person::Experience,
    University::Person::Involvement,
    University::Person::Localization,
    University::Person::Experience::Localization,
    University::Person::Involvement::Localization,
    University::Role::Localization
  ].freeze

  def perform
    date = Date.current - Lifecyclable::LIFECYCLE_DAYS_BEFORE_DELETION.days
    PARANOID_MODELS.each do |model_class|
      old_objects = model_class.only_deleted.where("deleted_at < ?", date.end_of_day)
      old_objects.find_each &:really_destroy!
    end
  end
end
