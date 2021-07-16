require "application_system_test_case"

class Qualiopi::IndicatorsTest < ApplicationSystemTestCase
  setup do
    @qualiopi_indicator = qualiopi_indicators(:one)
  end

  test "visiting the index" do
    visit qualiopi_indicators_url
    assert_selector "h1", text: "Qualiopi/Indicators"
  end

  test "creating a Indicator" do
    visit qualiopi_indicators_url
    click_on "New Qualiopi/Indicator"

    fill_in "Criterion", with: @qualiopi_indicator.criterion_id
    fill_in "Level expected", with: @qualiopi_indicator.level_expected
    fill_in "Name", with: @qualiopi_indicator.name
    fill_in "Non conformity", with: @qualiopi_indicator.non_conformity
    fill_in "Number", with: @qualiopi_indicator.number
    fill_in "Proof", with: @qualiopi_indicator.proof
    fill_in "Requirement", with: @qualiopi_indicator.requirement
    click_on "Create Indicator"

    assert_text "Indicator was successfully created"
    click_on "Back"
  end

  test "updating a Indicator" do
    visit qualiopi_indicators_url
    click_on "Edit", match: :first

    fill_in "Criterion", with: @qualiopi_indicator.criterion_id
    fill_in "Level expected", with: @qualiopi_indicator.level_expected
    fill_in "Name", with: @qualiopi_indicator.name
    fill_in "Non conformity", with: @qualiopi_indicator.non_conformity
    fill_in "Number", with: @qualiopi_indicator.number
    fill_in "Proof", with: @qualiopi_indicator.proof
    fill_in "Requirement", with: @qualiopi_indicator.requirement
    click_on "Update Indicator"

    assert_text "Indicator was successfully updated"
    click_on "Back"
  end

  test "destroying a Indicator" do
    visit qualiopi_indicators_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Indicator was successfully destroyed"
  end
end
