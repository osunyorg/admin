class Communication::Website::GitFile::GenerateContentJob < ApplicationJob
  queue_as :cats

  good_job_concurrency_rule(
    label: -> { "#{self.class.name}-#{queue_name}-#{arguments.first.to_global_id}" },
    enqueue_limit: 1,
    perform_limit: 1,
  )

  def perform(git_file)
    git_file.generate_content_safely
  end

end
