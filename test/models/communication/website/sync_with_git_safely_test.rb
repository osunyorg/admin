require "test_helper"

class Communication::Website::SyncWithGitSafelyTest < ActiveSupport::TestCase
  def desynchronize_a_git_file_for(website)
    git_file = website.git_files.generated.first
    assert git_file, "expected at least one generated git file in fixtures"
    git_file.update_columns(desynchronized: true, desynchronized_at: 1.hour.ago)
    git_file
  end

  test "does not call check_repository_access! when sync! succeeds" do
    desynchronize_a_git_file_for(website_with_github)

    repository = website_with_github.git_repository
    repository.define_singleton_method(:sync!) { nil }
    repository.define_singleton_method(:check_repository_access!) do
      flunk "check_repository_access! should not be called when sync! succeeds"
    end

    assert_nothing_raised do
      website_with_github.sync_with_git_safely
    end
  end

  test "re-raises the original error when check_repository_access! finds nothing wrong (transient failure)" do
    desynchronize_a_git_file_for(website_with_github)

    repository = website_with_github.git_repository
    repository.define_singleton_method(:sync!) { raise Octokit::InternalServerError.new }
    repository.define_singleton_method(:check_repository_access!) { nil }

    assert_raise Octokit::InternalServerError do
      website_with_github.sync_with_git_safely
    end
  end

  test "raises the precise typed error from check_repository_access! instead of the raw sync! error" do
    desynchronize_a_git_file_for(website_with_github)

    repository = website_with_github.git_repository
    repository.define_singleton_method(:sync!) { raise Octokit::Forbidden.new }
    repository.define_singleton_method(:check_repository_access!) do
      raise Git::Providers::Github::RepositoryForbidden, "no push access"
    end

    assert_raise Git::Providers::Github::RepositoryForbidden do
      website_with_github.sync_with_git_safely
    end
  end
end
