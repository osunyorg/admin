require "test_helper"

class University::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @university_organization = university_organizations(:one)
  end

  test "should get index" do
    get university_organizations_url
    assert_response :success
  end

  test "should get new" do
    get new_university_organization_url
    assert_response :success
  end

  test "should create university_organization" do
    assert_difference('University::Organization.count') do
      post university_organizations_url, params: { university_organization: { active: @university_organization.active, address: @university_organization.address, city: @university_organization.city, country: @university_organization.country, description: @university_organization.description, kind: @university_organization.kind, mail: @university_organization.mail, phone: @university_organization.phone, sirene: @university_organization.sirene, title: @university_organization.title, website: @university_organization.website, zipcode: @university_organization.zipcode } }
    end

    assert_redirected_to university_organization_url(University::Organization.last)
  end

  test "should show university_organization" do
    get university_organization_url(@university_organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_university_organization_url(@university_organization)
    assert_response :success
  end

  test "should update university_organization" do
    patch university_organization_url(@university_organization), params: { university_organization: { active: @university_organization.active, address: @university_organization.address, city: @university_organization.city, country: @university_organization.country, description: @university_organization.description, kind: @university_organization.kind, mail: @university_organization.mail, phone: @university_organization.phone, sirene: @university_organization.sirene, title: @university_organization.title, website: @university_organization.website, zipcode: @university_organization.zipcode } }
    assert_redirected_to university_organization_url(@university_organization)
  end

  test "should destroy university_organization" do
    assert_difference('University::Organization.count', -1) do
      delete university_organization_url(@university_organization)
    end

    assert_redirected_to university_organizations_url
  end
end
