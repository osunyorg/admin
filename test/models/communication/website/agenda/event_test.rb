require "test_helper"

class Communication::Website::Agenda::EventTest < ActiveSupport::TestCase
  test "valid cal file with specific dates and hours" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: Date.tomorrow + 1.day
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific hours on the same day" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: Date.tomorrow
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific hours but no end date" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: nil
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific dates but no end hour" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: Date.tomorrow + 1.day
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file on same day but no end hour" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: Date.tomorrow
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file on same day but no hours" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: Date.tomorrow
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file with specific dates but no hours" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: Date.tomorrow + 1.day
    )
    assert(event.valid?)
    event_l10n = event.localizations.first
    assert_nothing_raised { event_l10n.cal }
  end

  test "valid cal file but no end" do
    event = new_event(
      from_day: Date.tomorrow,
      to_day: nil
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
