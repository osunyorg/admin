class Communication::File::SynchronizeWithFileServerJob < ApplicationJob
  queue_as :donkeys

  def perform(file_localization)
    file_localization.sync_to_file_server_safely
  end
end
