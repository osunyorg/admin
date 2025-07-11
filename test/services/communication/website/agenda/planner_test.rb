require "test_helper"

# rails test test/services/communication/website/agenda/planner_test.rb
class Communication::Website::Agenda::PlannerTest < ActiveSupport::TestCase

  # test_event_time_slot                                    2024-07-12 08:00
  # recurring_time_slot_1                                   2025-06-01 07:00
  # federated_event_with_no_slot                            2025-06-03
  # federated_event_with_time_slots_time_slot_1             2025-06-20 00:00
  # federated_event_with_time_slots_time_slot_2             2025-06-23 00:00
  # child_1_no_slot                                         2025-07-01
  # recurring_time_slot_2                                   2025-07-01 07:00
  # parent                                                  2025-07-01
  # --- now
  # parent                                                  2025-07-02
  # child_2_single_slot_time_slot                           2025-07-02 07:00
  # child_4_multiple_slots_on_different_days_time_slot_1    2025-07-02 08:00
  # --- future
  # parent                                                  2025-07-03
  # child_3_multiple_slots_on_same_day_time_slot_1          2025-07-03 08:00
  # child_4_multiple_slots_on_different_days_time_slot_2    2025-07-03 08:30
  # child_3_multiple_slots_on_same_day_time_slot_2          2025-07-03 12:00
  # child_3_multiple_slots_on_same_day_time_slot_3          2025-07-03 16:00
  # parent                                                  2025-07-04
  # parent                                                  2025-07-05
  # child_4_multiple_slots_on_different_days_time_slot_3    2025-07-05 08:00
  # child_4_multiple_slots_on_different_days_time_slot_4    2025-07-05 20:00
  # simple                                                  2025-07-12
  # simple_single_slot_time_slot                            2025-07-15 09:00
  # recurring_time_slot_3                                   2025-08-01 07:00
  # recurring_time_slot_4                                   2025-09-01 07:00
  # recurring_time_slot_5                                   2025-10-01 07:00

  def test_planner_future_or_current
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_FUTURE_OR_CURRENT,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: true,
      include_children: true,
      include_recurring: true
    )
    assert_equal [
      event(:parent),
      time_slot(:child_2_single_slot_time_slot),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_1),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_1),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_2),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_2),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_3),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_3),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_4),
      event(:simple),
    ], planner.to_array
  end

  def test_planner_future_or_current_category
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_FUTURE_OR_CURRENT,
      category: category(:test_category),
      language: languages(:fr),
      quantity: 10,
      include_parents: true,
      include_children: true,
      include_recurring: true
    )
    assert_equal [
      event(:simple)
    ], planner.to_array
  end

  def test_planner_future_or_current_no_parents
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_FUTURE_OR_CURRENT,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: false,
      include_children: true,
      include_recurring: true
    )
    assert_equal [
      time_slot(:child_2_single_slot_time_slot),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_1),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_1),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_2),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_2),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_3),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_3),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_4),
      event(:simple),
      time_slot(:simple_single_slot_time_slot),
    ], planner.to_array
  end

  def test_planner_future_or_current_no_children
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_FUTURE_OR_CURRENT,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: true,
      include_children: false,
      include_recurring: true
    )
    assert_equal [
      event(:parent),
      event(:simple),
      time_slot(:simple_single_slot_time_slot),
      time_slot(:recurring_time_slot_3),
      time_slot(:recurring_time_slot_4),
      time_slot(:recurring_time_slot_5),
    ], planner.to_array
  end

  def test_planner_future_or_current_no_recurring
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_FUTURE_OR_CURRENT,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: true,
      include_children: true,
      include_recurring: false
    )
    assert_equal [
      event(:parent),
      time_slot(:child_2_single_slot_time_slot),
      event(:simple),
      time_slot(:simple_single_slot_time_slot),
    ], planner.to_array
  end

  def test_planner_current
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_CURRENT,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: true,
      include_children: true,
      include_recurring: true
    )
    assert_equal [
      event(:parent),
      time_slot(:child_2_single_slot_time_slot),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_1),
    ], planner.to_array
  end

  def test_planner_future
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_FUTURE,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: true,
      include_children: true,
      include_recurring: true
    )
    assert_equal [
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_1),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_2),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_2),
      time_slot(:child_3_multiple_slots_on_same_day_time_slot_3),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_3),
      time_slot(:child_4_multiple_slots_on_different_days_time_slot_4),
      event(:simple),
      time_slot(:simple_single_slot_time_slot),
      time_slot(:recurring_time_slot_3),
      time_slot(:recurring_time_slot_4),
    ], planner.to_array
  end

  def test_planner_archive
    travel_to Time.zone.parse("2025-07-02")
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_ARCHIVE,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: true,
      include_children: true,
      include_recurring: true
    )
    assert_equal [
      time_slot(:recurring_time_slot_2),
      event(:child_1_no_slot),
      time_slot(:federated_event_with_time_slots_time_slot_2),
      time_slot(:federated_event_with_time_slots_time_slot_1),
      event(:federated_event_with_no_slot),
      time_slot(:recurring_time_slot_1),
      time_slot(:test_event_time_slot),
    ], planner.to_array
  end

  protected

  def category(id)
    communication_website_agenda_categories(id)
  end

  def event(id)
    communication_website_agenda_events(id)
  end

  def time_slot(id)
    communication_website_agenda_event_time_slots(id)
  end
end