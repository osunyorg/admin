Delayed::Worker.queue_attributes = {
  high_priority: { priority: -10 },
  low_priority: { priority: 10 },
  imports: { priority: 5 }
}

# Avoid duplicates

# https://groups.google.com/g/delayed_job/c/gZ9bFCdZrsk#2a05c39a192e630c
# https://github.com/collectiveidea/delayed_job/blob/master/lib/delayed/backend/base.rb
# https://github.com/ignatiusreza/activejob-trackable

# based on https://gist.github.com/synth/fba7baeffd083a931184
require 'delayed_duplicate_prevention_plugin'

Delayed::Backend::ActiveRecord::Job.send(:include, DelayedDuplicatePreventionPlugin::SignatureConcern)
Delayed::Worker.plugins << DelayedDuplicatePreventionPlugin