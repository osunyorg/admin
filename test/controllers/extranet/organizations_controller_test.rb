require "test_helper"

class Extranet::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_search
    get search_organizations_path(term: "Organisation de test")
    assert_response(:success)
    results = JSON.parse(response.body)
    assert_equal(1, results.size)
    assert_equal("Organisation de test", results.first["label"])
  end

end
