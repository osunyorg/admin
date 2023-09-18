namespace :auto do

  desc 'Update publications from HAL for all researchers'
  task update_hal: :environment do
    # Research::Hal.update_from_api! is synchronous, we use a job for that
    Research::Hal::UpdateJob.perform_later
  end

  desc 'Clean and rebuild every website to enable publications in the future'
  task clean_and_rebuild_websites: :environment do
    Communication::Website.find_each do |website|
      # Communication::Website#clean_and_rebuild is asynchronous, no need for a intermediate job
      website.clean_and_rebuild
    end
  end

  desc 'Check SMS credits on SiB'
  task sib_sms_credits: :environment do
    Sendinblue::SmsCreditsWarningJob.perform_later
  end

end