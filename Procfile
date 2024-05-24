web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start --queues="default"
miceworker: bundle exec good_job start --queues="mice"
elephantworker: bundle exec good_job start --queues="elephant"
postdeploy: rails db:migrate && rails db:seed
