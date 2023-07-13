namespace :auto do

  desc 'Update publications from HAL for all researchers'
  task update_hal: :environment do
    Research::Hal::UpdateJob.perform_later
  end

  desc 'Resave every website to enable publications in the future'
  task save_and_sync_websites: :environment do
    Communication::Website.find_each do |website|
      website.rebuild_connections_and_git_files
    end
  end

end