require "test_helper"

class Communication::ExtranetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @communication_extranet = communication_extranets(:one)
  end

  test "should get index" do
    get communication_extranets_url
    assert_response :success
  end

  test "should get new" do
    get new_communication_extranet_url
    assert_response :success
  end

  test "should create communication_extranet" do
    assert_difference('Communication::Extranet.count') do
      post communication_extranets_url, params: { communication_extranet: { name: @communication_extranet.name, university_id: @communication_extranet.university_id, url: @communication_extranet.url } }
    end

    assert_redirected_to communication_extranet_url(Communication::Extranet.last)
  end

  test "should show communication_extranet" do
    get communication_extranet_url(@communication_extranet)
    assert_response :success
  end

  test "should get edit" do
    get edit_communication_extranet_url(@communication_extranet)
    assert_response :success
  end

  test "should update communication_extranet" do
    patch communication_extranet_url(@communication_extranet), params: { communication_extranet: { name: @communication_extranet.name, university_id: @communication_extranet.university_id, url: @communication_extranet.url } }
    assert_redirected_to communication_extranet_url(@communication_extranet)
  end

  test "should destroy communication_extranet" do
    assert_difference('Communication::Extranet.count', -1) do
      delete communication_extranet_url(@communication_extranet)
    end

    assert_redirected_to communication_extranets_url
  end
end
