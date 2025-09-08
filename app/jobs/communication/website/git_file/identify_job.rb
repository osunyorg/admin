class Communication::Website::GitFile::IdentifyJob < ApplicationJob
  queue_as :elephants

  def perform(record)
    record.identify_git_files_safely
  end

end
