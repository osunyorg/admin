class AddUnpublicationJobIdAndUnpublishedAtToCommunicationWebsitePostLocalizations < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_post_localizations, :unpublished_at, :datetime
    add_column :communication_website_post_localizations, :unpublication_job_id, :uuid
    add_index :communication_website_post_localizations, :unpublication_job_id, name: :idx_on_unpublication_job_id
    add_foreign_key :communication_website_post_localizations, :good_jobs, column: :unpublication_job_id, on_delete: :nullify, name: :fk_rails_unpublication_job_id
  end
end
