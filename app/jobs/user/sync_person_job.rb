class User::SyncPersonJob < ApplicationJob
  queue_as :mice

  def perform(user)
    user.sync_person_safely
  end
end