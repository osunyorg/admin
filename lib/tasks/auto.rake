namespace :auto do

  desc 'Update publications from HAL for all researchers'
  task update_hal: :environment do
    Research::Hal.update_from_api!
  end

  desc 'Resave every website to enable publications in the future'
  task save_and_sync_websites: :environment do
    Communication::Website.find_each do |website|
      website.save_and_sync
    end
  end

end