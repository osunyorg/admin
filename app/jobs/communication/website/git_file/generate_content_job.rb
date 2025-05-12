class Communication::Website::GitFile::GenerateContentJob < ApplicationJob
  def perform(git_file)
    git_file.generate_content_safely
  end
end