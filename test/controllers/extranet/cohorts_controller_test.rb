require "test_helper"

class Extranet::CohortsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get education_cohorts_path
    assert_response(:success)
  end

  def test_show
    get education_cohort_path(education_cohorts(:default_cohort))
    assert_response(:success)
  end
end
