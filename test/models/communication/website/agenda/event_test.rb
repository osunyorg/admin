# == Schema Information
#
# Table name: communication_website_agenda_events
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  from_day                 :date
#  from_hour                :time
#  meta_description         :text
#  published                :boolean          default(FALSE)
#  slug                     :string           indexed
#  subtitle                 :string
#  summary                  :text
#  time_zone                :string
#  title                    :string
#  to_day                   :date
#  to_hour                  :time
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_agenda_events_on_communication_website_id             (communication_website_id)
#  index_communication_website_agenda_events_on_language_id    (language_id)
#  index_communication_website_agenda_events_on_original_id    (original_id)
#  index_communication_website_agenda_events_on_parent_id      (parent_id)
#  index_communication_website_agenda_events_on_slug           (slug)
#  index_communication_website_agenda_events_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_00ca585c35  (university_id => universities.id)
#  fk_rails_5fa53206f2  (communication_website_id => communication_websites.id)
#  fk_rails_67834f0062  (language_id => languages.id)
#  fk_rails_917095d5ca  (parent_id => communication_website_agenda_events.id)
#  fk_rails_fc3fea77c2  (original_id => communication_website_agenda_events.id)
#
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
