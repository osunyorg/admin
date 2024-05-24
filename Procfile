web: bundle exec puma -C config/puma.rb
miceworker: bundle exec good_job start
elephantworker: bundle exec good_job start
postdeploy: rails db:migrate && rails db:seed
