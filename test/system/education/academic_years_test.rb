require "application_system_test_case"

class Education::AcademicYearsTest < ApplicationSystemTestCase
  setup do
    @education_academic_year = education_academic_years(:one)
  end

  test "visiting the index" do
    visit education_academic_years_url
    assert_selector "h1", text: "Education/Academic Years"
  end

  test "creating a Academic year" do
    visit education_academic_years_url
    click_on "New Education/Academic Year"

    fill_in "University", with: @education_academic_year.university_id
    fill_in "Year", with: @education_academic_year.year
    click_on "Create Academic year"

    assert_text "Academic year was successfully created"
    click_on "Back"
  end

  test "updating a Academic year" do
    visit education_academic_years_url
    click_on "Edit", match: :first

    fill_in "University", with: @education_academic_year.university_id
    fill_in "Year", with: @education_academic_year.year
    click_on "Update Academic year"

    assert_text "Academic year was successfully updated"
    click_on "Back"
  end

  test "destroying a Academic year" do
    visit education_academic_years_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Academic year was successfully destroyed"
  end
end
