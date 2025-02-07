class Search::BuildIndexJob < ApplicationJob
  queue_as :whale

  def perform
    Search.build_index
  end
end