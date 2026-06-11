class AddGeneratedAtToCommunicationGitFiles < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_git_files, :generated_at, :datetime
    Communication::Website::GitFile.reset_column_information
    Communication::Website::GitFile.update_all(generated_at: Time.zone.now)
  end
end
