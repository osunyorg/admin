class TrulyDestroySoftDeletedRecordsJob < ApplicationJob
  queue_as :default

  PARANOID_MODELS = [
    ActiveStorage::Attachment,
    Communication::Block,
    Communication::Website::Agenda::Event,
    Communication::Website::Agenda::Event::Localization,
    Communication::Website::Agenda::Exhibition,
    Communication::Website::Agenda::Exhibition::Localization,
    Communication::Website::Jobboard::Job,
    Communication::Website::Jobboard::Job::Localization,
    Communication::Website::Page,
    Communication::Website::Page::Localization,
    Communication::Website::Portfolio::Project,
    Communication::Website::Portfolio::Project::Localization,
    Communication::Website::Post,
    Communication::Website::Post::Localization,
    Education::Program,
    Education::Program::Localization,
    University::Organization,
    University::Organization::Localization,
    University::Person,
    University::Person::Localization
  ].freeze

  def perform
    date = Date.current - Lifecyclable::LIFECYCLE_DAYS_BEFORE_DELETION.days
    PARANOID_MODELS.each do |model_class|
      old_objects = model_class.only_deleted.where("deleted_at < ?", date.end_of_day)
      old_objects.find_each &:really_destroy!
    end
  end
end
