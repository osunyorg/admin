require "test_helper"

class Research::ResearchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @research_researcher = research_researchers(:one)
  end

  test "should get index" do
    get research_researchers_url
    assert_response :success
  end

  test "should get new" do
    get new_research_researcher_url
    assert_response :success
  end

  test "should create research_researcher" do
    assert_difference('Research::Researcher.count') do
      post research_researchers_url, params: { research_researcher: { biography: @research_researcher.biography, first_name: @research_researcher.first_name, last_name: @research_researcher.last_name, user_id: @research_researcher.user_id } }
    end

    assert_redirected_to research_researcher_url(Research::Researcher.last)
  end

  test "should show research_researcher" do
    get research_researcher_url(@research_researcher)
    assert_response :success
  end

  test "should get edit" do
    get edit_research_researcher_url(@research_researcher)
    assert_response :success
  end

  test "should update research_researcher" do
    patch research_researcher_url(@research_researcher), params: { research_researcher: { biography: @research_researcher.biography, first_name: @research_researcher.first_name, last_name: @research_researcher.last_name, user_id: @research_researcher.user_id } }
    assert_redirected_to research_researcher_url(@research_researcher)
  end

  test "should destroy research_researcher" do
    assert_difference('Research::Researcher.count', -1) do
      delete research_researcher_url(@research_researcher)
    end

    assert_redirected_to research_researchers_url
  end
end
