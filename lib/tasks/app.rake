namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    # Options
    Communication::Block.agenda.find_each do |block|
      template = block.template
      template.option_categories    = template.show_category
      template.option_summary       = template.show_summary
      template.option_status        = template.show_status
      block.save
    end
    Communication::Block.organizations.find_each do |block|
      template = block.template
      template.option_link          = template.with_link
      block.save
    end
    Communication::Block.pages.find_each do |block|
      template = block.template
      template.option_image         = template.show_image
      template.option_summary       = template.show_description
      block.save
    end
    Communication::Block.persons.find_each do |block|
      template = block.template
      template.option_image         = template.with_photo
      template.option_link          = template.with_link
      block.save
    end
    Communication::Block.posts.find_each do |block|
      template = block.template    
      template.option_author        = !template.hide_author
      template.option_categories    = !template.hide_category
      template.option_date          = !template.hide_date
      template.option_image         = !template.hide_image
      template.option_summary       = !template.hide_summary
      block.save
    end
    # Headings (pas de lien avec les options)
    Communication::Block::Heading.where(slug: nil).find_each do |heading|
      heading.set_slug
      heading.update_column :slug, heading.slug
    end
    
    # Set Deuxfleurs credentials, on database, then in GitHub repository's secrets
    deuxfleurs = Deuxfleurs.new
    Communication::Website.hosted_on_deuxfleurs.each do |website|
      next if website.deuxfleurs_access_key_id.present?
      begin
        bucket_info = deuxfleurs.get_bucket(website.deuxfleurs_identifier)
        # Set credentials on database
        website.update_columns(
          deuxfleurs_access_key_id: bucket_info[:access_key_id],
          deuxfleurs_secret_access_key: bucket_info[:secret_access_key]
        )
        # Set credentials on GitHub repository's secrets
        website.send(:deuxfleurs_update_github_secrets)
      rescue
        puts "Error while fixing « #{website} »"
      end
    end
  end

  namespace :websites do
    desc "Refresh access token for Communication Websites."
    task refresh_tokens: :environment do
      options = {}
      option_parser = OptionParser.new
      option_parser.banner = "Usage: rake app:websites:refresh_tokens -- --old=ghp_oldtoken --new=ghp_newtoken"
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
