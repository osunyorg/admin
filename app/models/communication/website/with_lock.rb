module Communication::Website::WithLock
  extend ActiveSupport::Concern

  included do
    LOCK_MAX_DURATION = 2.hours
  end

  def locked?
    reload
    locked_at.present? && locked_at > LOCK_MAX_DURATION.ago
  end

  def lock_for_background_jobs!
    raise if locked?
    update_column :locked_at, Time.zone.now
  end

  def unlock_for_background_jobs!
    update_column :locked_at, nil
  end
end
