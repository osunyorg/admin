namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    [
      "text", "biography", "accessibility", "contacts", "duration",
      "evaluation", "objectives", "opportunities", "other", "pedagogy",
      "prerequisites", "pricing", "registration", "content", "results"
    ].each do |attribute|
      ActiveStorage::Attachment.where(name: "#{attribute}_new_summernote_embeds").find_each { _1.update_column :name, "#{attribute}_summernote_embeds" }
    end
  end

  def clean_for_summernote(actiontext)
    return '' if actiontext.nil?
    actiontext.body
              .to_html
              .gsub('<div>', '<p>')
              .gsub('</div>', '</p>')
              .gsub('<strong>', '<b>')
              .gsub('</strong>', '</b>')
              .gsub('<em>', '<i>')
              .gsub('</em>', '</i>')
              .gsub('<p><br></p>', '')
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
