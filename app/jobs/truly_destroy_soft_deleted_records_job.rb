class TrulyDestroySoftDeletedRecordsJob < ApplicationJob
  queue_as :default

  PARANOID_MODELS = [
    ActiveStorage::Attachment,
    Communication::Website::Page::Localization,
    Communication::Website::Page
  ].freeze

  def perform
    date = Date.today - Lifecyclable::LIFECYCLE_DAYS_BEFORE_DELETION.days
    PARANOID_MODELS.each do |model_class|
      old_objects = model_class.only_deleted.where("deleted_at < ?", date)
      old_objects.find_each &:really_destroy!
    end
  end
end
