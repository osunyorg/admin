require "test_helper"

class Extranet::Alumni::CohortsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get alumni_education_cohorts_path
    assert_response(:success)
  end

  def test_show
    get alumni_education_cohort_path(education_cohorts(:default_cohort))
    assert_response(:success)
  end
end
