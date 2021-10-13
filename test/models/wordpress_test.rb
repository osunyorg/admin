require "test_helper"

class WordpressTest < ActiveSupport::TestCase
  test "the truth" do
    assert_equal Wordpress.clean('test'),
                 'test'
  end
end
