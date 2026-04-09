web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start --queues="default"
miceworker: bundle exec good_job start --queues="mice"
catsworker: bundle exec good_job start --queues="cats" --max-threads=2
elephantsworker: bundle exec good_job start --queues="elephants" --max-threads=1
whalesworker: bundle exec good_job start --queues="whales" --max-threads=1
unicornsworker: bundle exec good_job start --queues="unicorns" --max-threads=1
postdeploy: rails db:migrate && rails db:seed && rails app:fix
