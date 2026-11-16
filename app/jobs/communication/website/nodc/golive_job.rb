class Communication::Website::Nodc::GoliveJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.nodc_golive_safely
  end
end
