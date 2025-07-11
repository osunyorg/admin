require "test_helper"

# rails test test/services/communication/website/agenda/planner_test.rb
class Communication::Website::Agenda::PlannerTest < ActiveSupport::TestCase
  test "planner" do
    planner = Communication::Website::Agenda::Planner.new(
      website: website_with_github,
      time_scope: 'current_or_future',
      category: nil,
      language: languages(:fr),
      quantity: 10,
      include_parents: false,
      include_children: false,
      include_recurring: false
    )
    # TODO set today to 2025-07-02
    assert_equal planner.to_array.count, 5
  end
end