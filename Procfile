web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start --queues="default"
miceworker: bundle exec good_job start --queues="mice"
elephantworker: bundle exec good_job start --queues="elephant" --max-threads=1
whaleworker: bundle exec good_job start --queues="whale" --max-threads=1
migrationworker: bundle exec good_job start --queues="migration" --max-threads=1
postdeploy: rails db:migrate && rails db:seed
