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
      model_class.only_deleted.where("deleted_at < ?", Date.today - PARANOID_DELETION_DELAY).find_each do |record|
        record.really_destroy!
      end
    end
    
  end
end
