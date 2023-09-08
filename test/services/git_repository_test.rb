require "test_helper"

class GitRepositoryTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "incorrect credentials for github" do
    website_with_github.update(access_token: 'wrong access token')
    VCR.use_cassette(location) do
      assert_enqueued_emails 1 do
        provider = website_with_github.git_repository.send(:provider)
        provider.create_file '/path.txt', 'content'
        provider.push 'this is a commit'
      end
    end
  end

  test "file creation on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.create_file 'test.txt', 'content'
        result = provider.push 'Creating test.txt file'
      end
    end
  end

  test "file update on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.update_file 'test.txt', 'test.txt', 'new content'
        result = provider.push 'Updating test.txt file'
      end
    end
  end

  test "file move on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.update_file 'new_test.txt', 'test.txt', 'new content'
        result = provider.push 'Moving test.txt file'
      end
    end
  end

  test "file destroy on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.destroy_file 'new_test.txt'
        result = provider.push 'Destroying new_test.txt file'
      end
    end
  end

  test "incorrect credentials for gitlab" do
    VCR.use_cassette(location) do
      assert_enqueued_emails 1 do
        website_with_gitlab.update(access_token: 'wrong access token')
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.create_file '/path.txt', 'content'
        provider.push 'this is a commit'
      end
    end
  end

  test "file creation on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.create_file 'test.txt', 'content'
        result = provider.push 'Creating test.txt file'
      end
    end
  end

  test "file update on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.update_file 'test.txt', 'test.txt', 'new content'
        result = provider.push 'Updating test.txt file'
      end
    end
  end

  test "file move on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.update_file 'new_test.txt', 'test.txt', 'new content'
        result = provider.push 'Moving test.txt file'
      end
    end
  end

  test "file destroy on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.destroy_file 'new_test.txt'
        result = provider.push 'Destroying new_test.txt file'
      end
    end
  end
end
