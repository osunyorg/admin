class Communication::Website::Plausible::SetupJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.plausible_setup_safely
  end
end
