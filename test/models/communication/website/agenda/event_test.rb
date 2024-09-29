require "test_helper"

class Communication::Website::Agenda::EventTest < ActiveSupport::TestCase
  test "valid cal file with specific dates and hours" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: Date.tomorrow + 1.day,
      to_hour: "19:00"
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific hours on the same day" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: Date.tomorrow,
      to_hour: "19:00"
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific hours but no end date" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: nil,
      to_hour: "19:00"
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific dates but no end hour" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: Date.tomorrow + 1.day,
      to_hour: nil
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file on same day but no end hour" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: Date.tomorrow,
      to_hour: nil
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file on same day but no hours" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: nil,
      to_day: Date.tomorrow,
      to_hour: nil
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific dates but no hours" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: nil,
      to_day: Date.tomorrow + 1.day,
      to_hour: nil
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file but no end" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: nil,
      to_hour: nil
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  protected

  def new_event(**options)
    event = website_with_github.agenda_events.new(
      university_id: website_with_github.university_id,
      **options
    )
    event.localizations.build(title: "An event", language: website_with_github.default_language)
    event
  end
end
