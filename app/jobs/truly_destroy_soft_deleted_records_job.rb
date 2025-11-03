class TrulyDestroySoftDeletedRecordsJob < ApplicationJob
  queue_as :default

  PARANOID_MODELS = [
    ActiveStorage::Attachment,
    Communication::Website::Page::Localization,
    Communication::Website::Page
  ].freeze

  PARANOID_DELETION_DELAY = 30.days

  def perform
    PARANOID_MODELS.each do |model_class|
      old_objects = model_class.only_deleted.where("deleted_at < ?", Date.today - PARANOID_DELETION_DELAY)
      old_objects.find_each do |object|
        object.really_destroy!
      end
    end
  end
end
