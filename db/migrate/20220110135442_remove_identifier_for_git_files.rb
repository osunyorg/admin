class RemoveIdentifierForGitFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_git_files, :identifier
  end
end
