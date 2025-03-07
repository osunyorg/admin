class Communication::Website::Agenda::CreatePeriodsJob < ApplicationJob
  queue_as :elephant

  def perform(event_or_time_slot)
    website = event_or_time_slot.website
    value = event_or_time_slot.from_day.year
    return if Communication::Website::Agenda::Period::Year.exists_for?(website, value)
    begin
      pause_git_sync
      year = Communication::Website::Agenda::Period::Year.create_for(website, value)
    ensure
      unpause_git_sync
    end
    year.touch
    year.months.each(&:touch)
  end

  protected

  def object_classes
    [
      Communication::Website::Agenda::Period::Year,
      Communication::Website::Agenda::Period::Month,
      Communication::Website::Agenda::Period::Day
    ]
  end

  def localization_classes
    [
      Communication::Website::Agenda::Period::Year::Localization,
      Communication::Website::Agenda::Period::Month::Localization,
      Communication::Website::Agenda::Period::Day::Localization
    ]
  end

  def pause_git_sync
    object_classes.each do |object_class|
      object_class.skip_callback :save, :after, :connect_dependencies
      object_class.skip_callback :save, :after, :clean_websites_if_necessary
    end
    localization_classes.each do |localization_class|
      localization_class.skip_callback :save, :after, :connect_and_sync_direct_sources
      localization_class.skip_callback :touch, :after, :connect_and_sync_direct_sources
      localization_class.skip_callback :save, :after, :clean_websites_if_necessary
    end
  end

  def unpause_git_sync
    object_classes.each do |object_class|
      object_class.set_callback :save, :after, :connect_dependencies
      object_class.set_callback :save, :after, :clean_websites_if_necessary
    end
    localization_classes.each do |localization_class|
      localization_class.set_callback :save, :after, :connect_and_sync_direct_sources
      localization_class.set_callback :touch, :after, :connect_and_sync_direct_sources
      localization_class.set_callback :save, :after, :clean_websites_if_necessary
    end
  end
end
