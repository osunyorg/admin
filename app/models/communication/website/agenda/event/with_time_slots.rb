module Communication::Website::Agenda::Event::WithTimeSlots
  extend ActiveSupport::Concern

  included do
    has_many  :time_slots,
              foreign_key: :communication_website_agenda_event_id,
              dependent: :destroy
    accepts_nested_attributes_for :time_slots, allow_destroy: true
  end

  def time_slot_localizations
    Communication::Website::Agenda::Event::TimeSlot::Localization.where(about_id: time_slot_ids)
  end

  def save_time_slots(language, params)
    existing_slots_ids = []
    # Create slots
    params[:slots].each do |slot|
      next if slot[:date].blank?  || slot[:time].blank?
      date = slot[:date].to_date
      time = slot[:time].to_time
      datetime = Time.new date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.min,
                          time.sec,
                          ActiveSupport::TimeZone[time_zone]
      time_slot = save_time_slot(slot, datetime, language)
      existing_slots_ids << time_slot.id
    end
    # Delete obsolete slots
    time_slots.where.not(id: existing_slots_ids).each do |time_slot|
      time_slot.destroy
    end
    # Sync event after time slots save
    sync_with_git
  end

  # slot is a hash
  def save_time_slot(slot, datetime, language)
    if slot[:id].present?
      time_slot = time_slots.find(slot[:id])
      time_slot.datetime = datetime
    else
      time_slot = time_slots.where(
        university: university,
        website: website,
        datetime: datetime
      ).first_or_create
    end
    time_slot.duration = slot[:duration].to_i
    time_slot.save
    l10n = time_slot.localization_for(language)
    if l10n.nil?
      l10n = time_slot.localizations.build(
        language: language,
        website: website,
        university: university
      )
    end
    l10n.place = slot[:place]
    l10n.save
    time_slot
  end

  def time_slots_to_json(language)
    {
      min: from_day.iso8601,
      max: to_day.iso8601,
      slots: time_slots.ordered.map { |slot|
        l10n = slot.localization_for(language)
        {
          id: slot.id,
          date: slot.date.iso8601,
          time: slot.time,
          place: l10n&.place,
          duration: slot.duration
        }
      }
    }
  end
end