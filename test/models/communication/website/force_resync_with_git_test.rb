require "test_helper"

class Communication::Website::ForceResyncWithGitTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "force_resync_with_git! marks all generated git files as desynchronized, without syncing" do
    git_file = website_with_github.git_files.generated.first
    assert git_file, "expected at least one generated git file in fixtures"
    git_file.update_columns(desynchronized: false, desynchronized_at: nil)

    assert_no_enqueued_jobs only: Communication::Website::SyncWithGitJob do
      website_with_github.force_resync_with_git!
    end

    assert git_file.reload.desynchronized
  end

  test "changing repository marks all generated git files as desynchronized, without syncing" do
    # This test only checks the trigger on after_save.
    website_with_github.update_column(:access_token, nil)
    git_file = website_with_github.git_files.generated.first
    git_file.update_columns(desynchronized: false, desynchronized_at: nil)

    assert_no_enqueued_jobs only: Communication::Website::SyncWithGitJob do
      website_with_github.update!(repository: 'jtraulle/another-repo')
    end

    assert git_file.reload.desynchronized
  end

  test "changing git_provider marks all generated git files as desynchronized, without syncing" do
    website_with_github.update_column(:access_token, nil)
    git_file = website_with_github.git_files.generated.first
    git_file.update_columns(desynchronized: false, desynchronized_at: nil)

    assert_no_enqueued_jobs only: Communication::Website::SyncWithGitJob do
      website_with_github.update!(git_provider: :gitlab)
    end

    assert git_file.reload.desynchronized
  end

  test "does not mark files as desynchronized when an unrelated field changes" do
    git_file = website_with_github.git_files.generated.first
    git_file.update_columns(desynchronized: false, desynchronized_at: nil)

    website_with_github.update!(in_production: !website_with_github.in_production)

    refute git_file.reload.desynchronized
  end

  test "does not mark files as desynchronized when repository becomes blank" do
    website_with_github.update_column(:access_token, nil)
    git_file = website_with_github.git_files.generated.first
    git_file.update_columns(desynchronized: false, desynchronized_at: nil)

    website_with_github.update!(repository: nil)

    refute git_file.reload.desynchronized
  end
end
