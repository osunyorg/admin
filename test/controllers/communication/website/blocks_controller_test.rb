require "test_helper"

class Communication::Website::BlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @communication_website_block = communication_website_blocks(:one)
  end

  test "should get index" do
    get communication_website_blocks_url
    assert_response :success
  end

  test "should get new" do
    get new_communication_website_block_url
    assert_response :success
  end

  test "should create communication_website_block" do
    assert_difference('Communication::Website::Block.count') do
      post communication_website_blocks_url, params: { communication_website_block: { about_id: @communication_website_block.about_id, communication_website_id: @communication_website_block.communication_website_id, data: @communication_website_block.data, position: @communication_website_block.position, template: @communication_website_block.template, university_id: @communication_website_block.university_id } }
    end

    assert_redirected_to communication_website_block_url(Communication::Website::Block.last)
  end

  test "should show communication_website_block" do
    get communication_website_block_url(@communication_website_block)
    assert_response :success
  end

  test "should get edit" do
    get edit_communication_website_block_url(@communication_website_block)
    assert_response :success
  end

  test "should update communication_website_block" do
    patch communication_website_block_url(@communication_website_block), params: { communication_website_block: { about_id: @communication_website_block.about_id, communication_website_id: @communication_website_block.communication_website_id, data: @communication_website_block.data, position: @communication_website_block.position, template: @communication_website_block.template, university_id: @communication_website_block.university_id } }
    assert_redirected_to communication_website_block_url(@communication_website_block)
  end

  test "should destroy communication_website_block" do
    assert_difference('Communication::Website::Block.count', -1) do
      delete communication_website_block_url(@communication_website_block)
    end

    assert_redirected_to communication_website_blocks_url
  end
end
