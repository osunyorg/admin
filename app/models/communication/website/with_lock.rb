module Communication::Website::WithLock
  extend ActiveSupport::Concern

  included do
    class LockedError < StandardError; end

    # TODO use this to kill a task
    LOCK_MAX_DURATION = 2.hours
  end

  def locked_for_background_jobs?
    reload
    locked_at.present?
  end

  def lock_for_background_jobs_or_raise!
    if locked_for_background_jobs?
      raise LockedError.new("Website is locked for background jobs")
    else
      lock_for_background_jobs!
    end
  end

  def lock_for_background_jobs!
    update_column :locked_at, Time.zone.now
  end

  def unlock_for_background_jobs!
    update_column :locked_at, nil
  end
end
