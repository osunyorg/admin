require "application_system_test_case"

class Communication::Website::PagesTest < ApplicationSystemTestCase
  setup do
    @communication_website_page = communication_website_pages(:one)
  end

  test "visiting the index" do
    visit communication_website_pages_url
    assert_selector "h1", text: "Communication/Website/Pages"
  end

  test "creating a Page" do
    visit communication_website_pages_url
    click_on "New Communication/Website/Page"

    fill_in "About", with: @communication_website_page.about_id
    fill_in "Communication website", with: @communication_website_page.communication_website_id
    fill_in "Description", with: @communication_website_page.description
    fill_in "Kind", with: @communication_website_page.kind
    fill_in "Title", with: @communication_website_page.title
    fill_in "University", with: @communication_website_page.university_id
    click_on "Create Page"

    assert_text "Page was successfully created"
    click_on "Back"
  end

  test "updating a Page" do
    visit communication_website_pages_url
    click_on "Edit", match: :first

    fill_in "About", with: @communication_website_page.about_id
    fill_in "Communication website", with: @communication_website_page.communication_website_id
    fill_in "Description", with: @communication_website_page.description
    fill_in "Kind", with: @communication_website_page.kind
    fill_in "Title", with: @communication_website_page.title
    fill_in "University", with: @communication_website_page.university_id
    click_on "Update Page"

    assert_text "Page was successfully updated"
    click_on "Back"
  end

  test "destroying a Page" do
    visit communication_website_pages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Page was successfully destroyed"
  end
end
