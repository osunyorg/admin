namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    # Communication::Website::Post.find_each { |post| post.update(text: post.old_text) }
    # Communication::Website::Page.find_each { |page| page.update(text: page.old_text) }
    # Research::Researcher.find_each { |researcher| researcher.update(biography: researcher.old_biography) if researcher.biography.blank? }
    Research::Journal::Article.find_each { |article| article.update(text: article.old_text) if article.text.blank? }
    Communication::Website.find_each { |website|
      website.build_home(university_id: website.university_id).save if website.home.nil?
      website.update_column(:url, "https://#{website.url}") unless website.url.blank? || website.url.starts_with?('https://')
    }

    Education::Program.where(slug: [nil, '']).find_each { |program| program.update_column(:slug, program.name.parameterize) }
    Research::Journal::Article.where(slug: [nil, '']).find_each { |article| article.update_column(:slug, article.title.parameterize) }
    Research::Journal::Volume.where(slug: [nil, '']).find_each { |volume| volume.update_column(:slug, volume.title.parameterize) }
    Research::Researcher.where(slug: [nil, '']).find_each { |researcher| researcher.update_column(:slug, "#{researcher.first_name} #{researcher.last_name}".parameterize) }

    [
      Communication::Website::Author, Communication::Website::Category,
      Communication::Website::Home, Communication::Website::Menu,
      Communication::Website::Page, Communication::Website::Post
    ].each do |model|
      model.includes(:website).find_each do |object|
        next unless Github.with_website(object.website).valid?
        object.github_manifest.each do |manifest_item|
          Communication::Website::GithubFile.where(website: object.website, about: object, manifest_identifier: manifest_item[:identifier]).first_or_create do |github_file|
            github_file.github_path = object.github_path if manifest_item[:identifier] == 'primary'
          end
        end
      end
    end

    [
      Education::Program, Education::School, Education::Teacher,
      Research::Journal::Article, Research::Journal::Volume, Research::Researcher
    ].each do |model|
      model.includes(:websites).find_each do |object|
        object.websites.each do |website|
          next unless Github.with_website(website).valid?
          object.github_manifest.each do |manifest_item|
            Communication::Website::GithubFile.where(website: website, about: object, manifest_identifier: manifest_item[:identifier]).first_or_create do |github_file|
              github_file.github_path = object.github_path_generated if manifest_item[:identifier] == 'primary'
            end
          end
        end
      end
    end

    10.times do
      Education::Program.find_each { |p| p.update_column :path, "#{p.parent&.path}/#{p.slug}".gsub(/\/+/, '/') }
    end

    Communication::Website.all.find_each { |website|
      website.update_column(:authors_github_directory, "auteurs") if website.authors_github_directory.blank?
      website.update_column(:posts_github_directory, "actualites") if website.posts_github_directory.blank?
    }
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
