class Search::BuildIndexJob < ApplicationJob
  queue_as :whales

  def perform
    University::SearchResult.build_index
  end
end