require "application_system_test_case"

class Qualiopi::CriterionsTest < ApplicationSystemTestCase
  setup do
    @qualiopi_criterion = qualiopi_criterions(:one)
  end

  test "visiting the index" do
    visit qualiopi_criterions_url
    assert_selector "h1", text: "Qualiopi/Criterions"
  end

  test "creating a Criterion" do
    visit qualiopi_criterions_url
    click_on "New Qualiopi/Criterion"

    fill_in "Description", with: @qualiopi_criterion.description
    fill_in "Name", with: @qualiopi_criterion.name
    fill_in "Number", with: @qualiopi_criterion.number
    click_on "Create Criterion"

    assert_text "Criterion was successfully created"
    click_on "Back"
  end

  test "updating a Criterion" do
    visit qualiopi_criterions_url
    click_on "Edit", match: :first

    fill_in "Description", with: @qualiopi_criterion.description
    fill_in "Name", with: @qualiopi_criterion.name
    fill_in "Number", with: @qualiopi_criterion.number
    click_on "Update Criterion"

    assert_text "Criterion was successfully updated"
    click_on "Back"
  end

  test "destroying a Criterion" do
    visit qualiopi_criterions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Criterion was successfully destroyed"
  end
end
