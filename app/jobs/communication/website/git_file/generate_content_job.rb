class Communication::Website::GitFile::GenerateContentJob < ApplicationJob
  queue_as :mice

  def perform(git_file)
    git_file.generate_content_safely
  end

  good_job_control_concurrency_with(
    enqueue_limit: 1,
    perform_limit: 1,
    key: -> { "#{self.class.name}-#{queue_name}-#{arguments.first.to_global_id}" }
  )

end