require "test_helper"

class GitRepositoryTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "check_repository_access! invalidates access token for github" do
    VCR.use_cassette(location) do
      website_with_github.update_column(:access_token, 'wrong access token')
      assert_raise Git::Providers::Abstract::Unauthorized do
        website_with_github.git_repository.check_repository_access!
      end
    end
    assert_nil website_with_github.reload.access_token
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

  test "check_repository_access! invalidates access token for gitlab" do
    VCR.use_cassette(location) do
      website_with_gitlab.update_column(:access_token, 'wrong access token')
      assert_raise Git::Providers::Abstract::Unauthorized do
        website_with_gitlab.git_repository.check_repository_access!
      end
    end
    assert_nil website_with_gitlab.reload.access_token
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

  test "check_repository_access! invalidates access token for forgejo" do
    VCR.use_cassette(location) do
      website_with_forgejo.update_column(:access_token, 'wrong access token')
      assert_raise Git::Providers::Abstract::Unauthorized do
        website_with_forgejo.git_repository.check_repository_access!
      end
    end
    assert_nil website_with_forgejo.reload.access_token
  end

  test "check_repository_access! invalidates access token for forgejo when token is rejected on the version endpoint" do
    VCR.use_cassette(location) do
      website_with_forgejo.update_column(:access_token, 'wrong access token')
      assert_raise Git::Providers::Abstract::Unauthorized do
        website_with_forgejo.git_repository.check_repository_access!
      end
    end
    assert_nil website_with_forgejo.reload.access_token
  end

  test "file creation on forgejo" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_forgejo.git_repository.send(:provider)
        provider.create_file 'test.txt', 'content'
        result = provider.push 'Creating test.txt file'
      end
    end
  end

  test "file update on forgejo" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_forgejo.git_repository.send(:provider)
        provider.update_file 'test.txt', 'test.txt', 'new content'
        result = provider.push 'Updating test.txt file'
      end
    end
  end

  test "file move on forgejo" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_forgejo.git_repository.send(:provider)
        provider.update_file 'new_test.txt', 'test.txt', 'new content'
        result = provider.push 'Moving test.txt file'
      end
    end
  end

  test "file destroy on forgejo" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_forgejo.git_repository.send(:provider)
        provider.destroy_file 'new_test.txt'
        result = provider.push 'Destroying new_test.txt file'
      end
    end
  end

  # No VCR cassette because the repository format validation is local only
  test "invalid repository format is rejected before any network call, for every provider" do
    [website_with_github, website_with_gitlab, website_with_forgejo].each do |website|
      website.repository = 'not-a-valid-repo-format'
      assert_raise Git::Providers::Abstract::InvalidRepositoryIdentifier do
        website.git_repository.check_repository_access!
      end
    end
  end

  test "gitlab nested subgroup repository format is accepted, unlike github and forgejo" do
    website_with_gitlab.repository = 'group/subgroup/project'
    assert website_with_gitlab.repository.match?(Git::Providers::Gitlab::REPOSITORY_FORMAT)

    website_with_github.repository = 'group/subgroup/project'
    assert_raise Git::Providers::Abstract::InvalidRepositoryIdentifier do
      website_with_github.git_repository.check_repository_access!
    end

    website_with_forgejo.repository = 'group/subgroup/project'
    assert_raise Git::Providers::Abstract::InvalidRepositoryIdentifier do
      website_with_forgejo.git_repository.check_repository_access!
    end
  end

  test "repository format is validated at save time even without an access token" do
    website_with_github.access_token = nil
    website_with_github.repository = 'not-a-valid-repo-format'
    refute website_with_github.valid?
    assert_includes website_with_github.errors[:repository], I18n.t('activerecord.errors.models.communication/website.attributes.repository.invalid')
  end

  test "gitlab does not invalidate a valid token when only the repository is wrong" do
    provider = Git::Providers::Gitlab.allocate
    provider.instance_variable_set(:@repository, "owner/typo-repo")
    provider.instance_variable_set(:@branch, "main")
    provider.instance_variable_set(:@git_repository, website_with_gitlab.git_repository)

    scopes_response = Object.new
    def scopes_response.scopes; ["api"]; end

    parsed = Gitlab::ObjectifiedHash.new({ "message" => "401 Unauthorized" })
    fake_response = OpenStruct.new(
      code: 401, parsed_response: parsed, headers: { "content-type" => "application/json" },
      request: OpenStruct.new(base_uri: "https://gitlab.example.com", path: "/api/v4/projects/owner%2Ftypo-repo")
    )

    fake_client = Object.new
    fake_client.define_singleton_method(:get) { |*| scopes_response }
    fake_client.define_singleton_method(:project) { |*| raise Gitlab::Error::Unauthorized.new(fake_response) }
    provider.define_singleton_method(:client) { fake_client }

    token_before = website_with_gitlab.access_token
    assert_raise Git::Providers::Gitlab::RepositoryForbidden do
      provider.check_repository_push_access!
    end
    assert_equal token_before, website_with_gitlab.reload.access_token
  end
  
  test "forgejo does not invalidate a valid token when only the repository is wrong" do
    provider = Git::Providers::Forgejo.allocate
    provider.instance_variable_set(:@repository, "owner/typo-repo")
    provider.instance_variable_set(:@access_token, "good-token")
    provider.instance_variable_set(:@git_repository, website_with_forgejo.git_repository)

    fake_response = Net::HTTPNotFound.new("1.1", "404", "Not Found")
    def fake_response.body
      '{"message":"not found"}'
    end
    provider.define_singleton_method(:get_raw) do |*|
      raise Git::Providers::Concerns::RestClient::HTTPError.from_response(fake_response)
    end

    token_before = website_with_forgejo.access_token
    assert_raise Git::Providers::Forgejo::RepositoryNotFound do
      provider.send(:check_repository_push_access!)
    end
    assert_equal token_before, website_with_forgejo.reload.access_token
  end
end
