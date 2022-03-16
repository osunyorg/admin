require "test_helper"

class Education::AcademicYearsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @education_academic_year = education_academic_years(:one)
  end

  test "should get index" do
    get education_academic_years_url
    assert_response :success
  end

  test "should get new" do
    get new_education_academic_year_url
    assert_response :success
  end

  test "should create education_academic_year" do
    assert_difference('Education::AcademicYear.count') do
      post education_academic_years_url, params: { education_academic_year: { university_id: @education_academic_year.university_id, year: @education_academic_year.year } }
    end

    assert_redirected_to education_academic_year_url(Education::AcademicYear.last)
  end

  test "should show education_academic_year" do
    get education_academic_year_url(@education_academic_year)
    assert_response :success
  end

  test "should get edit" do
    get edit_education_academic_year_url(@education_academic_year)
    assert_response :success
  end

  test "should update education_academic_year" do
    patch education_academic_year_url(@education_academic_year), params: { education_academic_year: { university_id: @education_academic_year.university_id, year: @education_academic_year.year } }
    assert_redirected_to education_academic_year_url(@education_academic_year)
  end

  test "should destroy education_academic_year" do
    assert_difference('Education::AcademicYear.count', -1) do
      delete education_academic_year_url(@education_academic_year)
    end

    assert_redirected_to education_academic_years_url
  end
end
