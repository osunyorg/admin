class Communication::Website::CleanAndRebuildJob < Communication::Website::BaseJob
  def execute
    website.clean_and_rebuild
  end
end