require "test_helper"

class Communication::Website::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @communication_website_post = communication_website_posts(:one)
  end

  test "should get index" do
    get communication_website_posts_url
    assert_response :success
  end

  test "should get new" do
    get new_communication_website_post_url
    assert_response :success
  end

  test "should create communication_website_post" do
    assert_difference('Communication::Website::Post.count') do
      post communication_website_posts_url, params: { communication_website_post: { description: @communication_website_post.description, published: @communication_website_post.published, published_at: @communication_website_post.published_at, text: @communication_website_post.text, title: @communication_website_post.title, university_id: @communication_website_post.university_id, website_id: @communication_website_post.website_id } }
    end

    assert_redirected_to communication_website_post_url(Communication::Website::Post.last)
  end

  test "should show communication_website_post" do
    get communication_website_post_url(@communication_website_post)
    assert_response :success
  end

  test "should get edit" do
    get edit_communication_website_post_url(@communication_website_post)
    assert_response :success
  end

  test "should update communication_website_post" do
    patch communication_website_post_url(@communication_website_post), params: { communication_website_post: { description: @communication_website_post.description, published: @communication_website_post.published, published_at: @communication_website_post.published_at, text: @communication_website_post.text, title: @communication_website_post.title, university_id: @communication_website_post.university_id, website_id: @communication_website_post.website_id } }
    assert_redirected_to communication_website_post_url(@communication_website_post)
  end

  test "should destroy communication_website_post" do
    assert_difference('Communication::Website::Post.count', -1) do
      delete communication_website_post_url(@communication_website_post)
    end

    assert_redirected_to communication_website_posts_url
  end
end
