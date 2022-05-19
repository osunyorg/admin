require "test_helper"

class SummernoteCleanerTest < ActiveSupport::TestCase
  test "add p around text if missing" do
    text = 'Text<br><a href="#">link</a>'
    assert_equal '<p>Text<br><a href="#">link</a></p>', SummernoteCleaner.clean(text)
  end

  test "do nothing if p is there" do
    text = '<p>Text</p>'
    assert_equal '<p>Text</p>', SummernoteCleaner.clean(text)
  end

  test "add p before an existing p" do
    text = 'Text<p>Second text</p>'
    assert_equal '<p>Text</p><p>Second text</p>', SummernoteCleaner.clean(text)
  end
end
