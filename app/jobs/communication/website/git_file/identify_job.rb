class Communication::Website::GitFile::IdentifyJob < ApplicationJob
  def perform(record)
    record.identify_git_files_safely
  end
end
