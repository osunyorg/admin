require "test_helper"

class University::Organization::ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @university_organization_import = university_organization_imports(:one)
  end

  test "should get index" do
    get university_organization_imports_url
    assert_response :success
  end

  test "should get new" do
    get new_university_organization_import_url
    assert_response :success
  end

  test "should create university_organization_import" do
    assert_difference('University::Organization::Import.count') do
      post university_organization_imports_url, params: { university_organization_import: { university_id: @university_organization_import.university_id, user_id: @university_organization_import.user_id } }
    end

    assert_redirected_to university_organization_import_url(University::Organization::Import.last)
  end

  test "should show university_organization_import" do
    get university_organization_import_url(@university_organization_import)
    assert_response :success
  end

  test "should get edit" do
    get edit_university_organization_import_url(@university_organization_import)
    assert_response :success
  end

  test "should update university_organization_import" do
    patch university_organization_import_url(@university_organization_import), params: { university_organization_import: { university_id: @university_organization_import.university_id, user_id: @university_organization_import.user_id } }
    assert_redirected_to university_organization_import_url(@university_organization_import)
  end

  test "should destroy university_organization_import" do
    assert_difference('University::Organization::Import.count', -1) do
      delete university_organization_import_url(@university_organization_import)
    end

    assert_redirected_to university_organization_imports_url
  end
end
