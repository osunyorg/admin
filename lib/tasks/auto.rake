namespace :auto do

  desc 'Update publications from HAL for all researchers'
  task update_hal: :environment do
    # Research::Hal.update_from_api! is synchronous, we use a job for that
    Research::Hal::UpdateJob.perform_later
  end

  desc 'Clean and rebuild every website to enable publications in the future'
  task clean_and_rebuild_websites: :environment do
    Communication::Website.find_each do |website|
      website.clean_and_rebuild
    end
  end

  desc 'Synchronize every website'
  task synchronize_websites: :environment do
    Communication::Website.find_each do |website|
      next if website.git_files.desynchronized.none?
      Communication::Website::SyncWithGitJob.perform_later(website.id)
    end
  end

  desc 'Check SMS credits on SiB'
  task brevo_sms_credits: :environment do
    Brevo::SmsCreditsWarningJob.perform_later
  end

end