class Communication::Website::CleanJob < Communication::Website::BaseJob
  def execute
    website.clean
  end
end