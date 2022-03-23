require "application_system_test_case"

class University::Person::Alumnus::ImportsTest < ApplicationSystemTestCase
  setup do
    @university_person_alumnus_import = university_person_alumnus_imports(:one)
  end

  test "visiting the index" do
    visit university_person_alumnus_imports_url
    assert_selector "h1", text: "University/Person/Alumnus/Imports"
  end

  test "creating a Import" do
    visit university_person_alumnus_imports_url
    click_on "New University/Person/Alumnus/Import"

    fill_in "University", with: @university_person_alumnus_import.university_id
    fill_in "User", with: @university_person_alumnus_import.user_id
    click_on "Create Import"

    assert_text "Import was successfully created"
    click_on "Back"
  end

  test "updating a Import" do
    visit university_person_alumnus_imports_url
    click_on "Edit", match: :first

    fill_in "University", with: @university_person_alumnus_import.university_id
    fill_in "User", with: @university_person_alumnus_import.user_id
    click_on "Update Import"

    assert_text "Import was successfully updated"
    click_on "Back"
  end

  test "destroying a Import" do
    visit university_person_alumnus_imports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Import was successfully destroyed"
  end
end
