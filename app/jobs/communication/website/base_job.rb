class Communication::Website::BaseJob < ApplicationJob
  self.good_job_labels = ['website']

  include GoodJob::ActiveJobExtensions::InterruptErrors

  queue_as :elephant

  discard_on ActiveJob::DeserializationError

  # Retry the job after 1 minute if it is interrupted, to prevent queue from being blocked
  retry_on GoodJob::InterruptError, wait: 1.minute, attempts: Float::INFINITY
  # Retry the job after 5 seconds when the website was locked.
  retry_on Communication::Website::LockError, wait: 5.seconds, attempts: Float::INFINITY

  attr_accessor :website_id, :options

  def perform(website_id, options = {})
    @website_id = website_id
    @options = options
    # Website might be deleted in between
    return unless website.present?
    # Skip website lock if specified
    skip_website_lock = options.fetch(:skip_website_lock, false)
    if website.locked_for_background_jobs? && !skip_website_lock
      raise Communication::Website::LockError.new("Interrupted because of website lock.")
    end
    # We lock the website to prevent race conditions
    website.lock_for_background_jobs!
    begin
      # We execute the job
      execute
    ensure
      # We make sure to unlock the website to allow the other jobs to run
      website.unlock_for_background_jobs!
    end
  end

  protected

  def execute
    raise NotImplementedError
  end

  def website
    @website ||= Communication::Website.find_by(id: website_id)
  end
end