class AddPublicationJobIdToCommunicationWebsitePostLocalizations < ActiveRecord::Migration[8.0]
  def change
    add_reference :communication_website_post_localizations, :publication_job, foreign_key: { to_table: :good_jobs, on_delete: :nullify }, type: :uuid
  end
end
