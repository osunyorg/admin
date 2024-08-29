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
    assert_nothing_raised { event.cal }
  end

  test "valid cal file with specific hours on the same day" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: Date.tomorrow,
      to_hour: "19:00"
    )
    assert(event.valid?)
    assert_nothing_raised { event.cal }
  end

  test "valid cal file with specific hours but no end date" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: nil,
      to_hour: "19:00"
    )
    assert(event.valid?)
    assert_nothing_raised { event.cal }
  end

  test "valid cal file with specific dates but no end hour" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: Date.tomorrow + 1.day,
      to_hour: nil
    )
    assert(event.valid?)
    assert_nothing_raised { event.cal }
  end

  test "valid cal file on same day but no end hour" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: Date.tomorrow,
      to_hour: nil
    )
    assert(event.valid?)
    assert_nothing_raised { event.cal }
  end

  test "valid cal file on same day but no hours" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: nil,
      to_day: Date.tomorrow,
      to_hour: nil
    )
    assert(event.valid?)
    assert_nothing_raised { event.cal }
  end

  test "valid cal file with specific dates but no hours" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: nil,
      to_day: Date.tomorrow + 1.day,
      to_hour: nil
    )
    assert(event.valid?)
    assert_nothing_raised { event.cal }
  end

  test "valid cal file but no end" do
    event = new_event(
      from_day: Date.tomorrow,
      from_hour: "09:00",
      to_day: nil,
      to_hour: nil
    )
    assert(event.valid?)
    assert_nothing_raised { event.cal }
  end

  protected

  def new_event(**options)
    website_with_github.agenda_events.new(
      title: "An event",
      university_id: website_with_github.university_id,
      language_id: website_with_github.default_language_id,
      **options
    )
  end
end
