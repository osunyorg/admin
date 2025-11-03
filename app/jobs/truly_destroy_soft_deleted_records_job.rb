class TrulyDestroySoftDeletedRecordsJob < ApplicationJob
  queue_as :default

  PARANOID_MODELS = [
    ActiveStorage::Attachment,
    Communication::Website::Page::Localization,
    Communication::Website::Page
  ].freeze

  def perform
    PARANOID_MODELS.each do |model_class|
      model_class.only_deleted.where("deleted_at < ?", Date.today - Lifecyclable::LIFECYCLE_DAYS_BEFORE_DELETION.days).find_each do |record|
        record.really_destroy!
      end
    end
    
  end
end
