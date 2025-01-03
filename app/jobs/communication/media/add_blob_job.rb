class Communication::Media::AddBlobJob < Communication::Website::BaseJob
  queue_as :default

  def perform(blob)
    Communication::Media.create_from_blob(blob)
  end
end