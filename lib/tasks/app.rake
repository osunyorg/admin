namespace :app do
  desc 'Fix things'
  task fix: :environment do
    Communication::Website::Agenda::CreateTimeSlotsJob.perform_later
    Migrations::Agenda.migrate
  end

  namespace :search do
    task build_index: :environment do
      Search::BuildIndexJob.perform_later
    end
  end

  namespace :access_token do
    desc "Refresh access token for Universities & Websites."
    task refresh: :environment do
      options = {}
      option_parser = OptionParser.new
      option_parser.banner = "Usage: rake app:access_token:refresh -- --old=ghp_oldtoken --new=ghp_newtoken"
      option_parser.on("-o OLDTOKEN", "--old OLDTOKEN") do |old_access_token|
        options[:old_access_token] = old_access_token
      end
      option_parser.on("-n NEWTOKEN", "--new NEWTOKEN") do |new_access_token|
        options[:new_access_token] = new_access_token
      end
      args = option_parser.order!(ARGV) {}
      option_parser.parse!(args)

      websites = Communication::Website.where(access_token: options[:old_access_token])
      websites.each { |website|
        puts "Refreshing token for « #{website} »"
        website.update_column :access_token, options[:new_access_token]
      }
      universities = University.where(default_github_access_token: options[:old_access_token])
      universities.each { |university|
        puts "Refreshing token for « #{university} »"
        university.update_column :default_github_access_token, options[:new_access_token]
      }
      exit 0
    end
  end

  namespace :db do
    desc 'Get database from Scalingo'
    task :staging do
      Bundler.with_unbundled_env do
        Figaro.load # Load ENV variables
        # Get a new backup archive from Scalingo
        # PG Addon ID from `scalingo addons` CLI command.
        sh "scalingo --app #{ENV['OSUNY_STAGING_APP_NAME']} backups-create --addon #{ENV['OSUNY_STAGING_PG_ADDON_ID']}"
        sh "scalingo --app #{ENV['OSUNY_STAGING_APP_NAME']} backups-download --addon #{ENV['OSUNY_STAGING_PG_ADDON_ID']} --output db/scalingo-dump.tar.gz"

        sh 'rm -f db/latest.dump' # Remove an old backup file if it exists
        sh 'tar zxvf db/scalingo-dump.tar.gz -C db/' # Extract the new backup archive
        sh 'rm db/scalingo-dump.tar.gz' # Remove the backup archive
        sh 'mv db/*.pgsql db/latest.dump' # Rename the backup file
        sh 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop'
        sh 'bundle exec rails db:create'
        begin
          sh 'pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d osuny_development db/latest.dump'
        rescue
          'There were some warnings or errors while restoring'
        end
        sh 'rails db:migrate'
        sh 'rails db:seed'
      end
    end
  end
end
