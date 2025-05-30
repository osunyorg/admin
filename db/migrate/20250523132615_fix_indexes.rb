class FixIndexes < ActiveRecord::Migration[8.0]
  def change
    remove_index :communication_website_agenda_period_days, :university_id
    remove_index :communication_website_agenda_period_months, :university_id
    remove_index :communication_website_agenda_period_years, :university_id
    commit_db_transaction
    add_index :communication_blocks, [:university_id, :template_kind], algorithm: :concurrently
    add_index :communication_website_git_files, [:desynchronized_at], algorithm: :concurrently
    add_index :communication_website_git_files, [:website_id, :id], algorithm: :concurrently
  end
end
