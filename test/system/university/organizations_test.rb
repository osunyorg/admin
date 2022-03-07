require "application_system_test_case"

class University::OrganizationsTest < ApplicationSystemTestCase
  setup do
    @university_organization = university_organizations(:one)
  end

  test "visiting the index" do
    visit university_organizations_url
    assert_selector "h1", text: "University/Organizations"
  end

  test "creating a Organization" do
    visit university_organizations_url
    click_on "New University/Organization"

    check "Active" if @university_organization.active
    fill_in "Address", with: @university_organization.address
    fill_in "City", with: @university_organization.city
    fill_in "Country", with: @university_organization.country
    fill_in "Description", with: @university_organization.description
    fill_in "Kind", with: @university_organization.kind
    fill_in "Mail", with: @university_organization.mail
    fill_in "Phone", with: @university_organization.phone
    fill_in "Sirene", with: @university_organization.sirene
    fill_in "Title", with: @university_organization.title
    fill_in "Website", with: @university_organization.website
    fill_in "Zipcode", with: @university_organization.zipcode
    click_on "Create Organization"

    assert_text "Organization was successfully created"
    click_on "Back"
  end

  test "updating a Organization" do
    visit university_organizations_url
    click_on "Edit", match: :first

    check "Active" if @university_organization.active
    fill_in "Address", with: @university_organization.address
    fill_in "City", with: @university_organization.city
    fill_in "Country", with: @university_organization.country
    fill_in "Description", with: @university_organization.description
    fill_in "Kind", with: @university_organization.kind
    fill_in "Mail", with: @university_organization.mail
    fill_in "Phone", with: @university_organization.phone
    fill_in "Sirene", with: @university_organization.sirene
    fill_in "Title", with: @university_organization.title
    fill_in "Website", with: @university_organization.website
    fill_in "Zipcode", with: @university_organization.zipcode
    click_on "Update Organization"

    assert_text "Organization was successfully updated"
    click_on "Back"
  end

  test "destroying a Organization" do
    visit university_organizations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Organization was successfully destroyed"
  end
end
