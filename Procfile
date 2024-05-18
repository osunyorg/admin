web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start
postdeploy: rails db:migrate && rails db:seed
