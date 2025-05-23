class CreateCommunicationWebsiteJobboardJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_jobboard_jobs, id: :uuid do |t|
      t.string :bodyclass
      t.date :from_day
      t.date :to_day
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid, index: { name: 'index_jobboard_jobs_on_communication_website_id' }
      t.timestamps
    end
  end
end