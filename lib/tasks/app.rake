namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    {
      '7e153490-6230-479f-828c-072156fa7844' => 'www.aliceetlescryptotrolls.org',
      '3ccd06c9-5a99-44d3-8ffd-bc061bb200d7' => 'www.aorganisation.org',
      'c35fdb1e-8f27-4861-9299-3a0b1de075e4' => 'formation.osuny.org',
      'c48c69c3-028f-4719-9a3c-40b40f285ed0' => 'example.osuny.org',
      'a592b498-401d-4a04-8096-619e79c99373' => 'example-journal.osuny.org',
      '43823665-2bc0-4f2e-9908-9a2ea51d8923' => 'francoisnemeta',
      '6f38ca23-a2bf-4e18-a61a-ad3f8e173b39' => 'lab.noesya.coop',
      'ed7786de-7779-42b9-826e-eee1539e5f13' => 'levelesyeux',
      '5b500a04-660b-455a-baeb-615e2ecd17c5' => 'www.numeriqueinteretgeneral.org',
      '1a601e73-61f5-4c97-849f-7e8d56184c6c' => 'osuny.org',
      '826c808b-2234-410b-9756-79bb0b474c66' => 'presse.noesya.coop',
      '523447c2-67d0-4e3e-adb4-c4af6dd95fa4' => 'sane.noesya.coop',
      '6db97e73-44df-4d9a-9d43-8ada6ce1e1bd' => 'climbing.sebastiengaya.fr',
      '0aee4b28-85b6-463c-9395-f300fa131763' => 'support.osuny.org',
      'd6aae95e-0071-421a-8d2f-cca82901abeb' => 'works.noesya.coop',
      '0c5f68cd-12a0-4df1-bb48-f1d0541f9d37' => 'www.technorealisme.org',
      '330c8a78-486b-4a59-953c-22153a4538f0' => 'chatons',
      '72d9f79d-612f-426c-8b83-3be498a6be0a' => 'www.planetonstage.org',
      '4c5d277e-eded-4052-8461-1e72fe12294a' => 'movecommons',
      '5b5f01ed-3376-46a3-a113-80500f4d71cf' => 'lescodessurlatable',
      'e44bab13-4105-47bd-9577-f147af46ff5c' => 'labibliothech',
      '5ff011e4-e87f-451f-8d20-93d22bf7fc83' => 'idn-site',
      '40996a72-11c5-44d1-98c1-010d063f0cfb' => 'deuxfleurs-garage',
      '72b79e5c-bd2c-4531-bf8d-bf8f4e7ddd90' => 'cecilefreydf'
    }.each do |id, identifier|
      Communication::Website.find(id).update_columns  deuxfleurs_hosting: true,
                                                      deuxfleurs_identifier: identifier
    end
  end

  namespace :websites do
    desc "Refresh access token for Communication Websites."
    task refresh_tokens: :environment do
      options = {}
      option_parser = OptionParser.new
      option_parser.banner = "Usage: rake app:websites:refresh_tokens -- --old ghp_oldtoken --new ghp_newtoken"
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
