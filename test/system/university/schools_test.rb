require "application_system_test_case"

class University::SchoolsTest < ApplicationSystemTestCase
  setup do
    @university_school = university_schools(:one)
  end

  test "visiting the index" do
    visit university_schools_url
    assert_selector "h1", text: "University/Schools"
  end

  test "creating a School" do
    visit university_schools_url
    click_on "New University/School"

    fill_in "Address", with: @university_school.address
    fill_in "City", with: @university_school.city
    fill_in "Country", with: @university_school.country
    fill_in "Latitude", with: @university_school.latitude
    fill_in "Longitude", with: @university_school.longitude
    fill_in "Name", with: @university_school.name
    fill_in "University", with: @university_school.university_id
    fill_in "Zipcode", with: @university_school.zipcode
    click_on "Create School"

    assert_text "School was successfully created"
    click_on "Back"
  end

  test "updating a School" do
    visit university_schools_url
    click_on "Edit", match: :first

    fill_in "Address", with: @university_school.address
    fill_in "City", with: @university_school.city
    fill_in "Country", with: @university_school.country
    fill_in "Latitude", with: @university_school.latitude
    fill_in "Longitude", with: @university_school.longitude
    fill_in "Name", with: @university_school.name
    fill_in "University", with: @university_school.university_id
    fill_in "Zipcode", with: @university_school.zipcode
    click_on "Update School"

    assert_text "School was successfully updated"
    click_on "Back"
  end

  test "destroying a School" do
    visit university_schools_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "School was successfully destroyed"
  end
end
