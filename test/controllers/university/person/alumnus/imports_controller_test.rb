require "test_helper"

class University::Person::Alumnus::ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @university_person_alumnus_import = university_person_alumnus_imports(:one)
  end

  test "should get index" do
    get university_person_alumnus_imports_url
    assert_response :success
  end

  test "should get new" do
    get new_university_person_alumnus_import_url
    assert_response :success
  end

  test "should create university_person_alumnus_import" do
    assert_difference('University::Person::Alumnus::Import.count') do
      post university_person_alumnus_imports_url, params: { university_person_alumnus_import: { university_id: @university_person_alumnus_import.university_id, user_id: @university_person_alumnus_import.user_id } }
    end

    assert_redirected_to university_person_alumnus_import_url(University::Person::Alumnus::Import.last)
  end

  test "should show university_person_alumnus_import" do
    get university_person_alumnus_import_url(@university_person_alumnus_import)
    assert_response :success
  end

  test "should get edit" do
    get edit_university_person_alumnus_import_url(@university_person_alumnus_import)
    assert_response :success
  end

  test "should update university_person_alumnus_import" do
    patch university_person_alumnus_import_url(@university_person_alumnus_import), params: { university_person_alumnus_import: { university_id: @university_person_alumnus_import.university_id, user_id: @university_person_alumnus_import.user_id } }
    assert_redirected_to university_person_alumnus_import_url(@university_person_alumnus_import)
  end

  test "should destroy university_person_alumnus_import" do
    assert_difference('University::Person::Alumnus::Import.count', -1) do
      delete university_person_alumnus_import_url(@university_person_alumnus_import)
    end

    assert_redirected_to university_person_alumnus_imports_url
  end
end
