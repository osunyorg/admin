class Communication::Website::BaseJob < ApplicationJob
  self.good_job_labels = ['website']

  include GoodJob::ActiveJobExtensions::InterruptErrors

  queue_as :elephant

  discard_on ActiveJob::DeserializationError

  # Retry the job after 1 minute if it is interrupted, to prevent queue from being blocked
  retry_on GoodJob::InterruptError, wait: 1.minute, attempts: Float::INFINITY

  attr_accessor :website_id

  def perform(website_id)
    @website_id = website_id
    # Website might be deleted in between
    return unless website.present?
    # TODO manage lock / unlock
    execute
  end

  protected

  def execute
    raise NotImplementedError
  end

  def website
    @website ||= Communication::Website.find_by(id: website_id)
  end
end