require "test_helper"

# These tests confirm the dispatch logic of base_job.rb
# (discard_on/retry_on) by errors tagged as ClientError
class Communication::Website::ClientErrorDiscardTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  class FakeClientError < StandardError
    include Git::Providers::Abstract::ClientError
  end

  class FakeGenericProviderError < StandardError
  end

  class RaisingJob < Communication::Website::BaseJob
    def execute
      klass = options[:error_class].constantize
      raise klass.new(options[:error_message])
    end
  end

  test "discards immediately when tagged ClientError" do
    assert_enqueued_emails 2 do
      assert_nothing_raised do
        RaisingJob.perform_now(
          website_with_github.id,
          error_class: "Communication::Website::ClientErrorDiscardTest::FakeClientError",
          error_message: "bad request"
        )
      end
    end
  end

  test "confirms real gem classes are correctly tagged ClientError (ancestry)" do
    # Tagging native gem classes happens at class-definition time of each provider,
    # so force-load them here: this test must not depend on another test file
    # having autoloaded them first (Minitest randomizes run order).
    Git::Providers::Github
    Git::Providers::Gitlab
    Git::Providers::Forgejo

    assert Octokit::BadRequest.ancestors.include?(Git::Providers::Abstract::ClientError)
    assert Gitlab::Error::NotFound.ancestors.include?(Git::Providers::Abstract::ClientError)
    assert Git::Providers::Concerns::RestClient::HTTPError::Forbidden.ancestors.include?(Git::Providers::Abstract::ClientError)
    # Rate-limit : not tagged on purpose (transient, must continue to try)
    refute Octokit::TooManyRequests.ancestors.include?(Git::Providers::Abstract::ClientError)
    refute Gitlab::Error::TooManyRequests.ancestors.include?(Git::Providers::Abstract::ClientError)
    # Server errors : not tagged on purpose (transient, must continue to try)
    refute Octokit::InternalServerError.ancestors.include?(Git::Providers::Abstract::ClientError)
    refute Git::Providers::Concerns::RestClient::HTTPError::ServerError.ancestors.include?(Git::Providers::Abstract::ClientError)
  end
end
