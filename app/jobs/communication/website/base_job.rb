class Communication::Website::BaseJob < ApplicationJob
  self.good_job_labels = ['website']

  include GoodJob::ActiveJobExtensions::InterruptErrors

  queue_as :elephants

  # Discard if object does not exist anymore
  discard_on ActiveJob::DeserializationError

  # For any error not handled by our custom error classes in discard_on,
  # requests that return error are retried 5 times with exponential backoff
  # if it does not self-heal, notify admins with raw api error message.
  retry_on Git::Providers::Abstract::Error, wait: :polynomially_longer, attempts: 5 do |job, error|
    job.notify_git_access_broken(error)
  end

  # A client side error would not self-heal, notify admins.
  discard_on Git::Providers::Abstract::ClientError do |job, error|
    job.notify_git_access_broken(error)
  end

  # Discard immediately and notify admins
  # (a wrong or expired token does not come back on its own).
  discard_on Git::Providers::Abstract::Unauthorized do |job, error|
    job.notify_invalid_access_token
  end

  # Discard if the remote git access has drifted since it was last validated
  # (repository/branch deleted, branch newly protected, endpoint reconfigured...).
  # Unlike a generic network error, nothing self-heals this on the next run: notify admins.
  discard_on  Git::Providers::Abstract::RepositoryForbidden,
              Git::Providers::Abstract::RepositoryNotFound,
              Git::Providers::Abstract::BranchNotFound,
              Git::Providers::Abstract::BranchProtected,
              Git::Providers::Abstract::InvalidEndpoint,
              Git::Providers::Abstract::WorkflowsForbidden do |job, error|
    job.notify_git_access_broken(error)
  end

  # Retry the job after 1 minute if it is interrupted, to prevent queue from being blocked
  retry_on GoodJob::InterruptError, wait: 1.minute, attempts: Float::INFINITY
  # Retry the job after 30 seconds when the website was locked.
  retry_on Communication::Website::LockError, wait: 30.seconds, attempts: Float::INFINITY

  attr_accessor :website_id, :options

  def perform(website_id, options = {})
    @website_id = website_id
    @options = options
    # Website might be deleted in between
    return unless website.present?
    # Raise if website is locked to retry later
    raise Communication::Website::LockError.new("Interrupted because of website lock.") if website.locked_for_background_jobs?(job_id)
    # We lock the website to prevent race conditions
    website.lock_for_background_jobs!(job_id)
    begin
      # We execute the job
      execute
    ensure
      # We make sure to unlock the website to allow the other jobs to run
      website.unlock_for_background_jobs!
    end
  end

  def notify_git_access_broken(error)
    website&.notify_git_access_broken!(error)
  end

  def notify_invalid_access_token
    website&.notify_invalid_access_token!
  end

  protected

  def execute
    raise NoMethodError, "You must implement the `execute` method in #{self.class.name}"
  end

  def website
    @website ||= Communication::Website.find_by(id: website_id)
  end
end
