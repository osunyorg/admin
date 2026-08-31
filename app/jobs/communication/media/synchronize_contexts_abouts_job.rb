class Communication::Media::SynchronizeContextsAboutsJob < ApplicationJob
  queue_as :whales

  def perform(media)
    abouts(media).each do |about|
      next unless about.respond_to?(:identify_git_files_safely)
      Communication::Website::GitFile::IdentifyJob.perform_later(about)
    end
  end

  private

  def abouts(media)
    media.contexts
          .map { |context| context.about }
          .uniq
  end

end
