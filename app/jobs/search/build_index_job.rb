class Search::BuildIndexJob < ApplicationJob
  queue_as :whales

  def perform
    Search.build_index
  end
end