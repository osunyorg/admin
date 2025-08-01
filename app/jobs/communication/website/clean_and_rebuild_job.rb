class Communication::Website::CleanAndRebuildJob < Communication::Website::BaseJob
  queue_as :whales

  def execute
    website.clean_and_rebuild_safely
  end
end