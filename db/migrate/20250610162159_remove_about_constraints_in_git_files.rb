class RemoveAboutConstraintsInGitFiles < ActiveRecord::Migration[8.0]
  def change
    change_column_null :communication_website_git_files, :about_id, true
    change_column_null :communication_website_git_files, :about_type, true
  end
end
