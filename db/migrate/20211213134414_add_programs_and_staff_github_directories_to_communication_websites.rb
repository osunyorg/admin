class AddProgramsAndStaffGithubDirectoriesToCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :programs_github_directory, :string, default: 'programs'
    add_column :communication_websites, :staff_github_directory, :string, default: 'staff'
  end
end
