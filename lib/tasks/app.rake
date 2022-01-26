namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    Communication::Website.find_each { |website|
      website.build_home(university_id: website.university_id).save if website.home.nil?
      website.update_column(:url, "https://#{website.url}") unless website.url.blank? || website.url.starts_with?('https://')
    }

    Education::Program.where(slug: [nil, '']).find_each { |program| program.update_column(:slug, program.name.parameterize) }
    Research::Journal::Article.where(slug: [nil, '']).find_each { |article| article.update_column(:slug, article.title.parameterize) }
    Research::Journal::Volume.where(slug: [nil, '']).find_each { |volume| volume.update_column(:slug, volume.title.parameterize) }

    10.times do
      Education::Program.find_each { |p| p.update_column :path, "#{p.parent&.path}/#{p.slug}".gsub(/\/+/, '/') }
    end

    Communication::Website::Post.find_each do |post|
      post.categories = post.categories.select { |category| category.children.none? { |child| post.categories.include?(child) } }
    end

    Research::Journal::Article.where(position: nil).order(:published_at, :created_at).group_by(&:research_journal_volume_id).each do |_, articles|
      articles.each_with_index do |article, index|
        article.update_columns({
          published: article.published_at.present?,
          position: index + 1
        })
      end
    end

    # MICA & Class'Code
    Communication::Website.where(id: ["6dfb358c-21bc-440f-9156-e09b72671c32", "1bb0f013-4d3d-49be-84bc-087c8cff3c77"]).each do |website|
      website.imported_website.posts.find_each do |imported_post|
        imported_post.post&.update_column :published_at, imported_post.published_at
      end
    end

    Education::Program::Teacher.find_each { |teacher|
      involvement = University::Person::Involvement.where(
        kind: 'teacher',
        target: teacher.program,
        person_id: teacher.person_id,
        university_id: teacher.person.university_id
      ).first_or_create
      involvement.update_column(:description, teacher.description)
    }

    Education::Program::Role.find_each { |program_role|
      university_role = University::Role.where(
        description: program_role.title,
        target: program_role.program,
        position: program_role.position,
        university_id: program_role.university_id
      ).first_or_create

      program_role.people.find_each { |role_person|
        University::Person::Involvement.where(
          kind: 'administrator',
          target: university_role,
          person_id: role_person.person_id,
          position: role_person.position,
          university_id: program_role.university_id
        ).first_or_create
      }
    }

    Education::School::Administrator.find_each { |administrator|
      university_role = University::Role.where(
        description: administrator.description,
        target: administrator.school,
        university_id: administrator.person.university_id
      ).first_or_create

      University::Person::Involvement.where(
        kind: 'administrator',
        target: university_role,
        person_id: administrator.person_id,
        university_id: administrator.person.university_id
      ).first_or_create
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
