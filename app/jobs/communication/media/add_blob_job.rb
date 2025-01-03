class Communication::Media::AddBlobJob < Communication::Website::BaseJob
  queue_as :default

  def perform(blob)
    Communication::Media.add_blob(blob)
  end
end