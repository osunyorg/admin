class Communication::Website::Deuxfleurs::GoliveJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.deuxfleurs_golive_safely
  end
end
