class Communication::Website::GenerateGitFileJob < ApplicationJob
  def perform(git_file)
    git_file.generate
  end
end