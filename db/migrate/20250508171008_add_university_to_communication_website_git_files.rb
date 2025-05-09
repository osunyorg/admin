class AddUniversityToCommunicationWebsiteGitFiles < ActiveRecord::Migration[8.0]
  def change
    add_reference :communication_website_git_files, :university, null: true, foreign_key: true, type: :uuid
    Communication::Website::GitFile.find_each do |git_file|
      git_file.update_column(:university_id, git_file.website.university_id)
    end
    change_column_null :communication_website_git_files, :university_id, true
  end
end
