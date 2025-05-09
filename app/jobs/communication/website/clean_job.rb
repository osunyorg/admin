class Communication::Website::CleanJob < Communication::Website::BaseJob
  def execute
    website.clean_safely
  end
end