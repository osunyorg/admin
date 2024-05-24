web: bundle exec puma -C config/puma.rb
miceWorker: bundle exec good_job start
elephantWorker: bundle exec good_job start
postdeploy: rails db:migrate && rails db:seed
