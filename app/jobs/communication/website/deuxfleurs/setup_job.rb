class Communication::Website::Deuxfleurs::SetupJob < Communication::Website::BaseJob
  def execute
    website.deuxfleurs_setup_safely
  end
end