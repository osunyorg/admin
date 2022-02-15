namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    Communication::Website::Home.find_each do |object|
      object.update text_new: clean_for_summernote(object.text)
    end
    Communication::Website::Post.find_each do |object|
      object.update text_new: clean_for_summernote(object.text)
    end
    Communication::Website::Page.find_each do |object|
      object.update text_new: clean_for_summernote(object.text)
    end
    Research::Journal::Article.find_each do |object|
      object.update text_new: clean_for_summernote(object.text)
    end
    Research::Laboratory::Axis.find_each do |object|
      object.update text_new: clean_for_summernote(object.text)
    end
    University::Person.find_each do |object|
      object.update biography_new: clean_for_summernote(object.biography)
    end
    Education::Program.find_each do |object|
      object.update accessibility_new: clean_for_summernote(object.accessibility),
                    contacts_new: clean_for_summernote(object.contacts),
                    duration_new: clean_for_summernote(object.duration),
                    evaluation_new: clean_for_summernote(object.evaluation),
                    objectives_new: clean_for_summernote(object.objectives),
                    opportunities_new: clean_for_summernote(object.opportunities),
                    other_new: clean_for_summernote(object.other),
                    pedagogy_new: clean_for_summernote(object.pedagogy),
                    prerequisites_new: clean_for_summernote(object.prerequisites),
                    pricing_new: clean_for_summernote(object.pricing),
                    registration_new: clean_for_summernote(object.registration),
                    content_new: clean_for_summernote(object.content),
                    results_new: clean_for_summernote(object.results)
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
