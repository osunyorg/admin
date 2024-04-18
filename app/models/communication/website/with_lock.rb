module Communication::Website::WithLock
  extend ActiveSupport::Concern

  included do
    # TODO use this to kill a task
    LOCK_MAX_DURATION = 2.hours
  end

  def locked_for_background_jobs?
    reload
    locked_at.present?
  end

  def lock_for_background_jobs!
    update_column :locked_at, Time.zone.now
  end

  def unlock_for_background_jobs!
    update_column :locked_at, nil
  end
end
