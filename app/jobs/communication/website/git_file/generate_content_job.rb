class Communication::Website::GitFile::GenerateContentJob < ApplicationJob
  discard_on ActiveJob::DeserializationError

  def perform(git_file)
    git_file.generate_content_safely
  end
end