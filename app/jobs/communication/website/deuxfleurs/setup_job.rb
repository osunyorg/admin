class Communication::Website::Deuxfleurs::SetupJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.deuxfleurs_setup_safely
  end
end