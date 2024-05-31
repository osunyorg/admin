module Communication::Website::WithLock
  extend ActiveSupport::Concern

  included do
    # TODO use this to kill a task
    LOCK_MAX_DURATION = 2.hours
  end

  def locked_for_background_jobs?
    reload
    locked_at.present? && GoodJob::Job.running.find_by(id: locked_by_job_id).present?
  end

  def lock_for_background_jobs!(job_id)
    update_columns(
      locked_at: Time.zone.now,
      locked_by_job_id: job_id
    )
  end

  def unlock_for_background_jobs!
    update_columns(
      locked_at: nil,
      locked_by_job_id: nil
    )
  end
end
