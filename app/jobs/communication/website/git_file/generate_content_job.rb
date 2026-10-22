class Communication::Website::GitFile::GenerateContentJob < ApplicationJob
  queue_as :cats

  def perform(git_file)
    git_file.generate_content_safely
  end

  protected

  def digest_arguments(arguments)
    arguments.first.id
  end

end
