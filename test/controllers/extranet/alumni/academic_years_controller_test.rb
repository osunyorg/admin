require "test_helper"

class Extranet::Alumni::AcademicYearsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get alumni_administration_academic_years_path(lang: french)
    assert_response(:success)
  end

  def test_show
    get alumni_administration_academic_year_path(administration_academic_years(:twenty_two), lang: french)
    assert_response(:success)
  end
end
