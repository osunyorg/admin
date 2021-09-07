require "application_system_test_case"

class Research::ResearchersTest < ApplicationSystemTestCase
  setup do
    @research_researcher = research_researchers(:one)
  end

  test "visiting the index" do
    visit research_researchers_url
    assert_selector "h1", text: "Research/Researchers"
  end

  test "creating a Researcher" do
    visit research_researchers_url
    click_on "New Research/Researcher"

    fill_in "Biography", with: @research_researcher.biography
    fill_in "First name", with: @research_researcher.first_name
    fill_in "Last name", with: @research_researcher.last_name
    fill_in "User", with: @research_researcher.user_id
    click_on "Create Researcher"

    assert_text "Researcher was successfully created"
    click_on "Back"
  end

  test "updating a Researcher" do
    visit research_researchers_url
    click_on "Edit", match: :first

    fill_in "Biography", with: @research_researcher.biography
    fill_in "First name", with: @research_researcher.first_name
    fill_in "Last name", with: @research_researcher.last_name
    fill_in "User", with: @research_researcher.user_id
    click_on "Update Researcher"

    assert_text "Researcher was successfully updated"
    click_on "Back"
  end

  test "destroying a Researcher" do
    visit research_researchers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Researcher was successfully destroyed"
  end
end
