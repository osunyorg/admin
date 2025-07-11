require "test_helper"

# rails test test/services/communication/website/agenda/planner_test.rb
class Communication::Website::Agenda::PlannerTest < ActiveSupport::TestCase
  def test_planner
    travel_to Time.zone.parse("2025-07-02")
    
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: Communication::Website::Agenda::STATUS_CURRENT_OR_FUTURE,
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: false,
      include_children: false,
      include_recurring: false
    )
    assert_equal planner.to_array.count, 5
  end
end