class AddDefaultsToGitFiles < ActiveRecord::Migration[8.0]
  def change
    change_column_default :communication_website_git_files, :desynchronized, to: true, from: nil
  end
end
