# L'objet doit être un objet direct et avoir 1 attribut :
# - publication_job_id:references { to_table: :good_jobs, on_delete: :nullify }
module WithHourlyPublication
  extend ActiveSupport::Concern

  included do
    belongs_to :publication_job, class_name: 'GoodJob::Job', optional: true

    after_save_commit :manage_hourly_publication_job
    after_destroy :unschedule_publication_job
    after_restore :manage_hourly_publication_job
  end

  protected

  def manage_hourly_publication_job
    return unless website.feature_hourly_publication?
    if should_schedule_publication_job?
      schedule_publication_job
    elsif should_unschedule_publication_job?
      unschedule_publication_job
    end
  end

  def schedule_publication_job
    # First, we remove any existing publication job for this object
    unschedule_publication_job if publication_job.present?
    # Then, we schedule a new publication job and keep track of its ID
    identify_job = Communication::Website::Post::Localization::PublishJob
                    .set(wait_until: published_at)
                    .perform_later(self)
    update_column :publication_job_id, identify_job.job_id
  end

  def unschedule_publication_job
    publication_job&.destroy
  end

  def should_schedule_publication_job?
    # The object is published (not published?, which would do publish_now?)
    published &&
    # The publication state OR the publication date has changed
    (
      saved_change_to_published? || 
      saved_change_to_published_at?
    ) &&
    # The object was programmed to be published in the future
    published_at.present? && 
    published_at > Time.zone.now
  end

  def should_unschedule_publication_job?
    # The object was just unpublished
    (
      saved_change_to_published? && 
      !published
    ) ||
    # Or the publication date was changed to the past
    (
      saved_change_to_published_at? && 
      published_at.present? && 
      published_at <= Time.zone.now
    )
  end
end
