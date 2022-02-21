require "test_helper"

class GitRepositoryTest < ActiveSupport::TestCase
  test "incorrect credentials for github" do
    exception = assert_raises(Exception) do
      provider = Git::Providers::Github.new 'wrong token', 'username/repository'
      provider.create_file '/path.txt', 'content'
      provider.push 'this is a commit'
    end
    assert_equal exception.class, Octokit::Unauthorized
  end

  test "file creation on github" do
    provider = Git::Providers::Github.new 'correct token', 'username/repository'
    provider.create_file '/path.txt', 'content'
    result = provider.push 'this is a commit'
  end

  test "file update on github" do

  end

  test "file move on github" do

  end

  test "file destroy on github" do

  end
end
