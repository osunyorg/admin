class Communication::Website::Nodc::SetupJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.nodc_setup_safely
  end
end
