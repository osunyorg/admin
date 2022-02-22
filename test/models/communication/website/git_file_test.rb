require "test_helper"

class Communication::Website::GitFileTest < ActiveSupport::TestCase
  test "github should_create?" do
    file = communication_website_git_files(:git_file_1)
    # This is wrong! Fixtures must be prepared properly
    assert_not file.should_create?
  end

  test "github correct sha" do
    file = communication_website_git_files(:git_file_1)
    assert_equal file.sha, '5d387e7e2da68026aeb0cfc2e6a67f509a3e1ff6'
  end
end
