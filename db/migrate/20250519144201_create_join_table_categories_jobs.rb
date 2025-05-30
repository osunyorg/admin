class CreateJoinTableCategoriesJobs < ActiveRecord::Migration[8.0]
  def change
    create_table "communication_website_jobboard_categories_jobs", id: false, force: :cascade do |t|
      t.uuid "job_id", null: false
      t.uuid "category_id", null: false
      t.index ["category_id", "job_id"], name: "category_job"
      t.index ["job_id", "category_id"], name: "job_category"
    end
  end
end
