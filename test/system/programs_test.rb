require "application_system_test_case"

class ProgramsTest < ApplicationSystemTestCase
  setup do
    @program = programs(:one)
  end

  test "visiting the index" do
    visit programs_url
    assert_selector "h1", text: "Programs"
  end

  test "creating a Program" do
    visit programs_url
    click_on "New Program"

    fill_in "Accessibility", with: @program.accessibility
    fill_in "Capacity", with: @program.capacity
    check "Continuing" if @program.continuing
    fill_in "Duration", with: @program.duration
    fill_in "Ects", with: @program.ects
    fill_in "Evaluation", with: @program.evaluation
    fill_in "Level", with: @program.level
    fill_in "Name", with: @program.name
    fill_in "Objectives", with: @program.objectives
    fill_in "Pedagogy", with: @program.pedagogy
    fill_in "Prerequisites", with: @program.prerequisites
    fill_in "Registration", with: @program.registration
    fill_in "University", with: @program.university_id
    click_on "Create Program"

    assert_text "Program was successfully created"
    click_on "Back"
  end

  test "updating a Program" do
    visit programs_url
    click_on "Edit", match: :first

    fill_in "Accessibility", with: @program.accessibility
    fill_in "Capacity", with: @program.capacity
    check "Continuing" if @program.continuing
    fill_in "Duration", with: @program.duration
    fill_in "Ects", with: @program.ects
    fill_in "Evaluation", with: @program.evaluation
    fill_in "Level", with: @program.level
    fill_in "Name", with: @program.name
    fill_in "Objectives", with: @program.objectives
    fill_in "Pedagogy", with: @program.pedagogy
    fill_in "Prerequisites", with: @program.prerequisites
    fill_in "Registration", with: @program.registration
    fill_in "University", with: @program.university_id
    click_on "Update Program"

    assert_text "Program was successfully updated"
    click_on "Back"
  end

  test "destroying a Program" do
    visit programs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Program was successfully destroyed"
  end
end
