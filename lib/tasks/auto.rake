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
    Communication::Website.with_desynchronized_git_files.find_each do |website|
      puts "Sync website #{website.original_localization.to_s}"
      website.sync_with_git
    end
  end

  desc 'Take care of minor tasks'
  task daily_care: :environment do
    # Check SMS credits on SiB
    Brevo::SmsCreditsWarningJob.perform_later
    # Delete & warn old users due to GDPR
    GdprUserDeletionJob.perform_later
    # Reindex crucial tables for GoodJob
    # https://github.com/bensheldon/good_job/issues/896
    ActiveRecord::Base.connection.execute('REINDEX TABLE good_jobs')
    ActiveRecord::Base.connection.execute('REINDEX TABLE good_job_executions')
  end
end