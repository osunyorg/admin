require "test_helper"

class UniversitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @university = universities(:one)
  end

  test "should get index" do
    get universities_url
    assert_response :success
  end

  test "should get new" do
    get new_university_url
    assert_response :success
  end

  test "should create university" do
    assert_difference('University.count') do
      post universities_url, params: { university: { address: @university.address, city: @university.city, country: @university.country, name: @university.name, private: @university.private, zipcode: @university.zipcode } }
    end

    assert_redirected_to university_url(University.last)
  end

  test "should show university" do
    get university_url(@university)
    assert_response :success
  end

  test "should get edit" do
    get edit_university_url(@university)
    assert_response :success
  end

  test "should update university" do
    patch university_url(@university), params: { university: { address: @university.address, city: @university.city, country: @university.country, name: @university.name, private: @university.private, zipcode: @university.zipcode } }
    assert_redirected_to university_url(@university)
  end

  test "should destroy university" do
    assert_difference('University.count', -1) do
      delete university_url(@university)
    end

    assert_redirected_to universities_url
  end
end
