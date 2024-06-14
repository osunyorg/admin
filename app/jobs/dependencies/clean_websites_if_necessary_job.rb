class Dependencies::CleanWebsitesIfNecessaryJob < ApplicationJob
  queue_as :mice

  def perform(object_with_dependencies)
    object_with_dependencies.clean_websites_if_necessary_safely
  end
end
