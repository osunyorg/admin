require "test_helper"

class Communication::Website::PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @communication_website_page = communication_website_pages(:one)
  end

  test "should get index" do
    get communication_website_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_communication_website_page_url
    assert_response :success
  end

  test "should create communication_website_page" do
    assert_difference('Communication::Website::Page.count') do
      post communication_website_pages_url, params: { communication_website_page: { about_id: @communication_website_page.about_id, communication_website_id: @communication_website_page.communication_website_id, description: @communication_website_page.description, kind: @communication_website_page.kind, title: @communication_website_page.title, university_id: @communication_website_page.university_id } }
    end

    assert_redirected_to communication_website_page_url(Communication::Website::Page.last)
  end

  test "should show communication_website_page" do
    get communication_website_page_url(@communication_website_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_communication_website_page_url(@communication_website_page)
    assert_response :success
  end

  test "should update communication_website_page" do
    patch communication_website_page_url(@communication_website_page), params: { communication_website_page: { about_id: @communication_website_page.about_id, communication_website_id: @communication_website_page.communication_website_id, description: @communication_website_page.description, kind: @communication_website_page.kind, title: @communication_website_page.title, university_id: @communication_website_page.university_id } }
    assert_redirected_to communication_website_page_url(@communication_website_page)
  end

  test "should destroy communication_website_page" do
    assert_difference('Communication::Website::Page.count', -1) do
      delete communication_website_page_url(@communication_website_page)
    end

    assert_redirected_to communication_website_pages_url
  end
end
