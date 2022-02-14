require "test_helper"

class SummernoteTest < ActiveSupport::TestCase
  test "dehydrate" do
    post = Communication::Website::Post.new university: university(:test),
                                            website: communication_website(:test),
                                            title: 'test',
                                            slug: 'test'
    post.text_new = "<action-text-attachment sgid=\"sgid\" content-type=\"image/jpeg\" url=\"http://localhost:3000/dan-gold.jpeg\" filename=\"test.jpg\" filesize=\"352931\" width=\"588\" height=\"746\" previewable=\"true\" presentation=\"gallery\">
      <figure class=\"attachment attachment--preview attachment--jpg\">
        <picture>
          <source srcset=\"/rails/active_storage/representations/redirect/eyJfcmFpbHMiOns...watchingwindows_com_08.jpg 100w, /rails/active_storage/representations/redirect/eyJfcmFpbHMiOns...watchingwindows_com_08.jpg 200w\" type=\"image/webp\">
          <source srcset=\"/rails/active_storage/representations/redirect/eyJfcmFpbHMiOns...watchingwindows_com_08.jpg 100w, /rails/active_storage/representations/redirect/eyJfcmFpbHMiOns...watchingwindows_com_08.jpg\" type=\"image/jpeg\">
          <img src=\"/rails/active_storage/representations/redirect/eyJfcmFpbHMiOns...watchingwindows_com_08.jpg\" loading=\"lazy\" decoding=\"async\" width=\"800\">
        </picture>
      </figure>
    </action-text-attachment>"
    post.save
    post.reload
    assert_equal "<action-text-attachment sgid=\"sgid\" content-type=\"image/jpeg\" url=\"http://localhost:3000/dan-gold.jpeg\" filename=\"test.jpg\" filesize=\"352931\" width=\"588\" height=\"746\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment>", post.text_new_before_type_cast
  end
end
