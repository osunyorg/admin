require "test_helper"

class Extranet::Alumni::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get alumni_university_organizations_path(lang: french)
    assert_response(:success)
  end

  def test_show
    get alumni_university_organization_path(university_organizations(:default_organization), lang: french)
    assert_response(:success)
  end
end
