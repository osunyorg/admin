class ApplicationJob < ActiveJob::Base
  # https://github.com/bensheldon/good_job?tab=readme-ov-file#labelled-jobs
  include GoodJob::ActiveJobExtensions::Labels

  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
