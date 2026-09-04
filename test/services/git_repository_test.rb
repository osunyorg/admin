require "test_helper"

class GitRepositoryTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  # note: this case does not send email anymore, a credential error on GH will just crash the task
  test "incorrect credentials for github" do
    website_with_github.update(access_token: 'wrong access token')
    VCR.use_cassette(location) do
      assert_raise Octokit::Unauthorized do
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

  test "no push on github when synchronization is locked" do
    # Note: no VCR needed as no real HTTP requests should be made
    website_with_github.lock_synchronization! users(:admin)
    provider = website_with_github.git_repository.send(:provider)
    provider.create_file 'test.txt', 'content'
    assert_nil provider.push('Creating test.txt file')
  end

  test "git files stay desynchronized when synchronization is locked" do
    git_file = communication_website_git_files(:git_file_2)
    website_with_github.lock_synchronization! users(:admin)
    repository = website_with_github.git_repository
    repository.git_files = [git_file]
    assert_nil repository.sync!
    assert git_file.reload.desynchronized
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

  test "no push on gitlab when synchronization is locked" do
    # Note: no VCR needed as no real HTTP requests should be made
    website_with_gitlab.lock_synchronization! users(:admin)
    provider = website_with_gitlab.git_repository.send(:provider)
    provider.create_file 'test.txt', 'content'
    assert_nil provider.push('Creating test.txt file')
  end

  test "no sync job enqueued when synchronization is locked" do
    website_with_github.lock_synchronization! users(:admin)
    assert_no_enqueued_jobs only: Communication::Website::SyncWithGitJob do
      website_with_github.sync_with_git
      # git_file_2 stays desynchronized, but the job must not requeue itself
      website_with_github.sync_with_git_safely
    end
  end
end
