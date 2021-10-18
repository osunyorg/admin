namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    language = Language.first
    User.find_each { |u|
      u.confirm
      u.role ||= :visitor
      u.language ||= language
      u.save
    }
  end

  namespace :db do
    desc 'Get database from Scalingo'
    task :staging do
    end
  end
end
