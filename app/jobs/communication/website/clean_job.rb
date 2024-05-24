class Communication::Website::CleanJob < Communication::Website::BaseJob
  queue_as :low_priority

  def execute
    website.clean
  end
end