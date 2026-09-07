require "test_helper"

# rails test test/models/communication/website/with_git_repository_test.rb
class Communication::Website::WithGitRepositoryTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "lock and unlock synchronization" do
    refute website_with_github.synchronization_locked?
    website_with_github.lock_synchronization! users(:admin)
    assert website_with_github.synchronization_locked?
    website_with_github.unlock_synchronization!
    refute website_with_github.synchronization_locked?
  end

  test "jobs are enqueued only when unlocked" do
    # Locked: nothing is enqueued
    website_with_github.lock_synchronization! users(:admin)
    assert_no_enqueued_jobs do
      website_with_github.sync_with_git
      website_with_github.sync_with_git_safely
      website_with_github.update_theme_version
    end

    # Unlocking re-triggers a sync for desynchronized generated git files
    assert_enqueued_jobs 1, only: Communication::Website::SyncWithGitJob do
      website_with_github.unlock_synchronization!
    end
    
    # Unlocked: jobs run normally
    assert_enqueued_jobs 1, only: Communication::Website::UpdateThemeVersionJob do
      website_with_github.update_theme_version
    end

  end
end
