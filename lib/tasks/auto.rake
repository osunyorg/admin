namespace :auto do
  desc 'Update publications from HAL for all researchers'
  task update_hal: :environment do
    Research::Hal.update_from_api!
  end

  desc 'Save all websites to update connections and clean Git repositories'
  task save_and_sync_websites: :environment do
    Communication::Website.save_and_sync_websites!
  end
end