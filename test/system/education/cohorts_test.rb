require "application_system_test_case"

class Education::CohortsTest < ApplicationSystemTestCase
  setup do
    @education_cohort = education_cohorts(:one)
  end

  test "visiting the index" do
    visit education_cohorts_url
    assert_selector "h1", text: "Education/Cohorts"
  end

  test "creating a Cohort" do
    visit education_cohorts_url
    click_on "New Education/Cohort"

    fill_in "Academic year", with: @education_cohort.academic_year_id
    fill_in "Name", with: @education_cohort.name
    fill_in "Program", with: @education_cohort.program_id
    fill_in "University", with: @education_cohort.university_id
    click_on "Create Cohort"

    assert_text "Cohort was successfully created"
    click_on "Back"
  end

  test "updating a Cohort" do
    visit education_cohorts_url
    click_on "Edit", match: :first

    fill_in "Academic year", with: @education_cohort.academic_year_id
    fill_in "Name", with: @education_cohort.name
    fill_in "Program", with: @education_cohort.program_id
    fill_in "University", with: @education_cohort.university_id
    click_on "Update Cohort"

    assert_text "Cohort was successfully updated"
    click_on "Back"
  end

  test "destroying a Cohort" do
    visit education_cohorts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cohort was successfully destroyed"
  end
end
