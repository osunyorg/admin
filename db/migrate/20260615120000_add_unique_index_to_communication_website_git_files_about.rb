class AddUniqueIndexToCommunicationWebsiteGitFilesAbout < ActiveRecord::Migration[8.1]
  def up
    add_index :communication_website_git_files,
              [:website_id, :about_type, :about_id],
              unique: true,
              where: "(about_id IS NOT NULL)",
              name: "index_git_files_unique_about_per_website"
  end

  def down
    remove_index :communication_website_git_files,
                 name: "index_git_files_unique_about_per_website"
  end
end
