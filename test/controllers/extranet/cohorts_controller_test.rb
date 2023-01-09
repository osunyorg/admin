require "test_helper"

class Extranet::CohortsControllerTest < ActionDispatch::IntegrationTest
  def setup
    host! "extranet.osuny"
    sign_in_with_2fa(alumnus)
  end

  def test_index
    get education_cohorts_path
    assert_response(:success)
  end

  def test_show
    get education_cohort_path(education_cohorts(:default_cohort))
    assert_response(:success)
  end
end
