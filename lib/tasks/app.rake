namespace :app do
  desc 'Start server'
  task :start do
    sh 'yarn'
    sh 'rails tmp:cache:clear'
    sh 'rails server'
  end

  desc 'Fix things'
  task fix: :environment do
    
  end

  namespace :db do
    desc 'Get database from Scalingo'
    task :staging do
    end
  end
end
