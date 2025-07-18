# L'objet doit être un objet direct et avoir 1 attribut :
# - publication_job_id:references { to_table: :good_jobs, on_delete: :nullify }
module WithHourlyPublication
  extend ActiveSupport::Concern

  included do
    after_save_commit :schedule_publication_job, if: :should_schedule_publication_job?
  end

  def schedule_publication_job
    # First, we remove any existing publication job for this object
    GoodJob::Job.find_by(id: publication_job_id)&.destroy if publication_job_id.present?
    # Then, we schedule a new publication job and keep track of its ID
    identify_job = Communication::Website::Post::PublishJob
                    .set(wait_until: published_at)
                    .perform_later(about)
    update_column :publication_job_id, identify_job.job_id
  end

  protected

  def should_schedule_publication_job?
    # The feature must be enabled
    website.feature_hourly_publication? &&
    # The object is published
    published &&
    # The publication state OR the publication date has changed
    (saved_change_to_published? || saved_change_to_published_at?) &&
    # The object was programmed to be published in the future
    published_at.present? && published_at > Time.zone.now
  end
end
