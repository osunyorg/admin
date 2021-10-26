require "test_helper"

class University::SchoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @university_school = university_schools(:one)
  end

  test "should get index" do
    get university_schools_url
    assert_response :success
  end

  test "should get new" do
    get new_university_school_url
    assert_response :success
  end

  test "should create university_school" do
    assert_difference('University::School.count') do
      post university_schools_url, params: { university_school: { address: @university_school.address, city: @university_school.city, country: @university_school.country, latitude: @university_school.latitude, longitude: @university_school.longitude, name: @university_school.name, university_id: @university_school.university_id, zipcode: @university_school.zipcode } }
    end

    assert_redirected_to university_school_url(University::School.last)
  end

  test "should show university_school" do
    get university_school_url(@university_school)
    assert_response :success
  end

  test "should get edit" do
    get edit_university_school_url(@university_school)
    assert_response :success
  end

  test "should update university_school" do
    patch university_school_url(@university_school), params: { university_school: { address: @university_school.address, city: @university_school.city, country: @university_school.country, latitude: @university_school.latitude, longitude: @university_school.longitude, name: @university_school.name, university_id: @university_school.university_id, zipcode: @university_school.zipcode } }
    assert_redirected_to university_school_url(@university_school)
  end

  test "should destroy university_school" do
    assert_difference('University::School.count', -1) do
      delete university_school_url(@university_school)
    end

    assert_redirected_to university_schools_url
  end
end
