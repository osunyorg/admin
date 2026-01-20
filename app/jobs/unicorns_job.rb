# Magic jobs for magic devs
class UnicornsJob < ApplicationJob
  queue_as :unicorns

  def perform
    Communication::Website::Agenda::Period::Day::Localization.find_each &:save
    Communication::Website::Agenda::Period::Month::Localization.find_each &:save
    Communication::Website::Agenda::Period::Year::Localization.find_each &:save
  end
end