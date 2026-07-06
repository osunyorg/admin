# L'objet doit être un objet direct et avoir 1 attribut :
# - unpublication_job_id:references { to_table: :good_jobs, on_delete: :nullify }
module PublishableUnpublishable
  extend ActiveSupport::Concern

  included do
    belongs_to :unpublication_job, class_name: 'GoodJob::Job', optional: true

    after_save_commit :manage_unpublication_job
    after_destroy :unschedule_unpublication_job
    after_restore :schedule_unpublication_job if :need_unpublication_job?
  end

  protected

  def manage_unpublication_job
    if should_schedule_unpublication_job?
      schedule_unpublication_job
    elsif should_unschedule_unpublication_job?
      unschedule_unpublication_job
    end
  end

  def schedule_unpublication_job
    # First, we remove any existing unpublication job for this object
    unschedule_unpublication_job if unpublication_job.present?
    # Then, we schedule a new unpublication job and keep track of its ID
    identify_job = Communication::Website::Post::Localization::UnpublishJob
                    .set(wait_until: unpublished_at)
                    .perform_later(self)
    update_column :unpublication_job_id, identify_job.job_id
  end

  def unschedule_unpublication_job
    unpublication_job&.destroy
  end

  def need_unpublication_job?
    # The object is published
    published &&
    # The object was programmed to be unpublished in the future
    unpublished_at.present? &&
    unpublished_at > Time.zone.now
  end

  def should_schedule_unpublication_job?
    need_unpublication_job? &&
    # The publication state or the unpublication date has changed
    (
      saved_change_to_published? ||
      saved_change_to_unpublished_at?
    )
  end

  def should_unschedule_unpublication_job?
    # The object was just unpublished
    (
      saved_change_to_published? &&
      !published
    ) ||
    # Or the unpublication date was removed or changed to the past
    (
      saved_change_to_unpublished_at? &&
      (
        unpublished_at.blank? ||
        unpublished_at <= Time.zone.now
      )
    )
  end
end
