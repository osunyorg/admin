# Magic jobs for magic devs
class UnicornsJob < ApplicationJob
  queue_as :unicorns

  def perform
    Communication::Website::Agenda::Period::Day::Localization.find_each { |l10n| l10n.denormalize_events_count }
  end
end