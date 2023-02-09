namespace :auto do
  desc 'Update publications from HAL for all researchers'
  task update_publications_from_hal: :environment do
    Research::Publication.update_from_hal
  end
end