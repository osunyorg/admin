require "test_helper"

class Extranet::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get university_organizations_path
    assert_response(:success)
  end

  def test_search
    get search_university_organizations_path(term: "Organisation de test")
    assert_response(:success)
    results = JSON.parse(response.body)
    assert_equal(1, results.size)
    assert_equal("Organisation de test", results.first["label"])
  end

  def test_show
    get university_organization_path(university_organizations(:default_organization))
    assert_response(:success)
  end
end
