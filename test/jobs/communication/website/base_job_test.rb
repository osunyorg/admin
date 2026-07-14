require "test_helper"

class Communication::Website::BaseJobTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  # Dummy job with the only purpose to raise the corresponding error
  class RaisingJob < Communication::Website::BaseJob
    def execute
      klass = options[:error_class].constantize
      # Octokit::Error expects a response object (hash), not a raw text message
      raise options[:error_message] ? klass.new(options[:error_message]) : klass.new
    end
  end

  test "notifies admins and discards cleanly when Github access is forbidden" do
    assert_enqueued_emails 2 do
      assert_nothing_raised do
        RaisingJob.perform_now(
          website_with_github.id,
          error_class: "Git::Providers::Github::RepositoryForbidden",
          error_message: "no push access"
        )
      end
    end
  end

  test "notifies admins and discards cleanly when Gitlab become protected" do
    assert_enqueued_emails 2 do
      assert_nothing_raised do
        RaisingJob.perform_now(
          website_with_gitlab.id,
          error_class: "Git::Providers::Gitlab::BranchProtected",
          error_message: "branch is protected"
        )
      end
    end
  end

  test "notifies admins and discards cleanly when Forgejo repository access does not exists anymore" do
    assert_enqueued_emails 2 do
      assert_nothing_raised do
        RaisingJob.perform_now(
          website_with_forgejo.id,
          error_class: "Git::Providers::Forgejo::RepositoryNotFound",
          error_message: "repository not found"
        )
      end
    end
  end

  test "notifies admins via the invalid access token mail, not git-access-broken, when Unauthorized reaches the job" do
    assert_enqueued_emails 2 do
      assert_nothing_raised do
        RaisingJob.perform_now(
          website_with_forgejo.id,
          error_class: "Git::Providers::Forgejo::Unauthorized",
          error_message: "bad token"
        )
      end
    end
  end
end
