require "test_helper"

class Extranet::Alumni::AcademicYearsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get alumni_education_academic_years_path
    assert_response(:success)
  end

  def test_show
    get alumni_education_academic_year_path(education_academic_years(:twenty_two))
    assert_response(:success)
  end
end
