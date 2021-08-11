require "application_system_test_case"

class Features::Websites::SitesTest < ApplicationSystemTestCase
  setup do
    @features_websites_site = features_websites_sites(:one)
  end

  test "visiting the index" do
    visit features_websites_sites_url
    assert_selector "h1", text: "Features/Websites/Sites"
  end

  test "creating a Site" do
    visit features_websites_sites_url
    click_on "New Features/Websites/Site"

    fill_in "Domain", with: @features_websites_site.domain
    fill_in "Name", with: @features_websites_site.name
    click_on "Create Site"

    assert_text "Site was successfully created"
    click_on "Back"
  end

  test "updating a Site" do
    visit features_websites_sites_url
    click_on "Edit", match: :first

    fill_in "Domain", with: @features_websites_site.domain
    fill_in "Name", with: @features_websites_site.name
    click_on "Update Site"

    assert_text "Site was successfully updated"
    click_on "Back"
  end

  test "destroying a Site" do
    visit features_websites_sites_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Site was successfully destroyed"
  end
end
