require "application_system_test_case"

class Communication::Website::PostsTest < ApplicationSystemTestCase
  setup do
    @communication_website_post = communication_website_posts(:one)
  end

  test "visiting the index" do
    visit communication_website_posts_url
    assert_selector "h1", text: "Communication/Website/Posts"
  end

  test "creating a Post" do
    visit communication_website_posts_url
    click_on "New Communication/Website/Post"

    fill_in "Description", with: @communication_website_post.description
    fill_in "Published", with: @communication_website_post.published
    fill_in "Published at", with: @communication_website_post.published_at
    fill_in "Text", with: @communication_website_post.text
    fill_in "Title", with: @communication_website_post.title
    fill_in "University", with: @communication_website_post.university_id
    fill_in "Website", with: @communication_website_post.website_id
    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Back"
  end

  test "updating a Post" do
    visit communication_website_posts_url
    click_on "Edit", match: :first

    fill_in "Description", with: @communication_website_post.description
    fill_in "Published", with: @communication_website_post.published
    fill_in "Published at", with: @communication_website_post.published_at
    fill_in "Text", with: @communication_website_post.text
    fill_in "Title", with: @communication_website_post.title
    fill_in "University", with: @communication_website_post.university_id
    fill_in "Website", with: @communication_website_post.website_id
    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Back"
  end

  test "destroying a Post" do
    visit communication_website_posts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Post was successfully destroyed"
  end
end
