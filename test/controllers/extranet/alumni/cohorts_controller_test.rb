require "test_helper"

class Extranet::Alumni::CohortsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get alumni_administration_cohorts_path(lang: french)
    assert_response(:success)
  end

  def test_show
    get alumni_administration_cohort_path(administration_cohorts(:default_cohort), lang: french)
    assert_response(:success)
  end
end
