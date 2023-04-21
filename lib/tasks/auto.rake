namespace :auto do

  desc 'Update publications from HAL for all researchers'
  task update_hal: :environment do
    Research::Hal.update_from_api!
  end

end