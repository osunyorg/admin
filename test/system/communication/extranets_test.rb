require "application_system_test_case"

class Communication::ExtranetsTest < ApplicationSystemTestCase
  setup do
    @communication_extranet = communication_extranets(:one)
  end

  test "visiting the index" do
    visit communication_extranets_url
    assert_selector "h1", text: "Communication/Extranets"
  end

  test "creating a Extranet" do
    visit communication_extranets_url
    click_on "New Communication/Extranet"

    fill_in "Name", with: @communication_extranet.name
    fill_in "University", with: @communication_extranet.university_id
    fill_in "Url", with: @communication_extranet.url
    click_on "Create Extranet"

    assert_text "Extranet was successfully created"
    click_on "Back"
  end

  test "updating a Extranet" do
    visit communication_extranets_url
    click_on "Edit", match: :first

    fill_in "Name", with: @communication_extranet.name
    fill_in "University", with: @communication_extranet.university_id
    fill_in "Url", with: @communication_extranet.url
    click_on "Update Extranet"

    assert_text "Extranet was successfully updated"
    click_on "Back"
  end

  test "destroying a Extranet" do
    visit communication_extranets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Extranet was successfully destroyed"
  end
end
