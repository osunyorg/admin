class AddUniversityToCommunicationWebsiteGitFiles < ActiveRecord::Migration[8.0]
  def change
    add_reference :communication_website_git_files, :university, null: true, foreign_key: true, type: :uuid
    Communication::Website::GitFile.reset_column_information
    Communication::Website.find_each do |website|
      website.website_git_files.update_all(university_id: website.university_id)
    end
    change_column_null :communication_website_git_files, :university_id, false
  end
end
