module Communication::Website::WithLock
  extend ActiveSupport::Concern

  included do
    # TODO use this to kill a task
    LOCK_MAX_DURATION = 2.hours
  end

  def locked_for_background_jobs?(executing_job_id)
    reload
    # Website is locked if locked_at is present and the job which locked it is not the current job
    locked_at.present? && locked_by_job_id != executing_job_id
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
