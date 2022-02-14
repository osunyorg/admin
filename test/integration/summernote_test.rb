require "test_helper"

class SummernoteTest < ActiveSupport::TestCase
  HTML_HYDRATED = "<action-text-attachment sgid=\"sgid\" content-type=\"image/jpeg\" url=\"http://localhost:3000/dan-gold.jpeg\" filename=\"test.jpg\" filesize=\"352931\" width=\"588\" height=\"746\" previewable=\"true\" presentation=\"gallery\"><figure class=\"attachment attachment--preview\">\n  <img width=\"588\" height=\"746\" src=\"http://localhost:3000/dan-gold.jpeg\">\n</figure></action-text-attachment>\n"
  HTML_DEHYDRATED = "<action-text-attachment sgid=\"sgid\" content-type=\"image/jpeg\" url=\"http://localhost:3000/dan-gold.jpeg\" filename=\"test.jpg\" filesize=\"352931\" width=\"588\" height=\"746\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment>"

  test "dehydrate actiontext" do
    post = communication_website_post(:test)
    post.text_new = HTML_HYDRATED
    post.save
    post.reload
    assert_equal HTML_DEHYDRATED, post.text_new_before_type_cast
  end

  test "rehydrate actiontext" do
    post = communication_website_post(:test)
    post.text_new = HTML_DEHYDRATED
    post.save
    post.reload
    assert_equal HTML_HYDRATED, communication_website_post(:test).text_new.to_s
  end
 end
