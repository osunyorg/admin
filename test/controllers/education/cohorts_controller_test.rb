require "test_helper"

class Education::CohortsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @education_cohort = education_cohorts(:one)
  end

  test "should get index" do
    get education_cohorts_url
    assert_response :success
  end

  test "should get new" do
    get new_education_cohort_url
    assert_response :success
  end

  test "should create education_cohort" do
    assert_difference('Education::Cohort.count') do
      post education_cohorts_url, params: { education_cohort: { academic_year_id: @education_cohort.academic_year_id, name: @education_cohort.name, program_id: @education_cohort.program_id, university_id: @education_cohort.university_id } }
    end

    assert_redirected_to education_cohort_url(Education::Cohort.last)
  end

  test "should show education_cohort" do
    get education_cohort_url(@education_cohort)
    assert_response :success
  end

  test "should get edit" do
    get edit_education_cohort_url(@education_cohort)
    assert_response :success
  end

  test "should update education_cohort" do
    patch education_cohort_url(@education_cohort), params: { education_cohort: { academic_year_id: @education_cohort.academic_year_id, name: @education_cohort.name, program_id: @education_cohort.program_id, university_id: @education_cohort.university_id } }
    assert_redirected_to education_cohort_url(@education_cohort)
  end

  test "should destroy education_cohort" do
    assert_difference('Education::Cohort.count', -1) do
      delete education_cohort_url(@education_cohort)
    end

    assert_redirected_to education_cohorts_url
  end
end
