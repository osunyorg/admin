class Communication::Website::GitFile::GenerateContentJob < ApplicationJob
  queue_as :cats

  good_job_concurrency_rule(
    enqueue_limit: 1,
    perform_limit: 1,
    label: -> { "#{self.class.name}-#{queue_name}-#{arguments.first.to_global_id}" }
  )

  def perform(git_file)
    git_file.generate_content_safely
  end

end
