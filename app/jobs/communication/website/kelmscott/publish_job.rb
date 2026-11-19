class Communication::Website::Kelmscott::PublishJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.kelmscott_publish_safely
  end
end
