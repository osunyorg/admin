require "test_helper"

class GitRepositoryTest < ActiveSupport::TestCase
  test "incorrect credentials for github" do
    VCR.use_cassette(location) do
      exception = assert_raises(Exception) do
        provider = Git::Providers::Github.new 'wrong token', 'username/repository'
        provider.create_file '/path.txt', 'content'
        provider.push 'this is a commit'
      end
      assert_equal exception.class, Octokit::Unauthorized
    end
  end

  test "file creation on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = Git::Providers::Github.new ENV['TEST_GITHUB_TOKEN'], ENV['TEST_GITHUB_REPOSITORY']
        provider.create_file 'test.txt', 'content'
        result = provider.push 'Creating test.txt file'
      end
    end
  end

  test "file update on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = Git::Providers::Github.new ENV['TEST_GITHUB_TOKEN'], ENV['TEST_GITHUB_REPOSITORY']
        provider.update_file 'test.txt', 'test.txt', 'new content'
        result = provider.push 'Updating test.txt file'
      end
    end
  end

  test "file move on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = Git::Providers::Github.new ENV['TEST_GITHUB_TOKEN'], ENV['TEST_GITHUB_REPOSITORY']
        provider.update_file 'new_test.txt', 'test.txt', 'new content'
        result = provider.push 'Moving test.txt file'
      end
    end
  end

  test "file destroy on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = Git::Providers::Github.new ENV['TEST_GITHUB_TOKEN'], ENV['TEST_GITHUB_REPOSITORY']
        provider.destroy_file 'new_test.txt'
        result = provider.push 'Destroying new_test.txt file'
      end
    end
  end
end
