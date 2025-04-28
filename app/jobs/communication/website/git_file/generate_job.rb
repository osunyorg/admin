class Communication::Website::GitFile::GenerateJob < ApplicationJob
  def perform(git_file)
    git_file.generate
  end
end