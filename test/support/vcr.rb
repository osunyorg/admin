require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = false
  c.filter_sensitive_data('<TEST_GITHUB_TOKEN>') { ENV['TEST_GITHUB_TOKEN'] }
  c.filter_sensitive_data('<TEST_GITHUB_REPOSITORY>') { ENV['TEST_GITHUB_REPOSITORY'] }
  c.filter_sensitive_data('<TEST_GITLAB_TOKEN>') { ENV['TEST_GITLAB_TOKEN'] }
  c.filter_sensitive_data('<TEST_GITLAB_REPOSITORY>') { ENV['TEST_GITLAB_REPOSITORY'] }
  c.filter_sensitive_data('<TEST_GITLAB_REPOSITORY_ENCODED>') { CGI.escape(ENV['TEST_GITLAB_REPOSITORY'].to_s) }
  c.filter_sensitive_data('<TEST_GITLAB_ENDPOINT>') { ENV['TEST_GITLAB_ENDPOINT'] }
  c.filter_sensitive_data('<TEST_FORGEJO_TOKEN>') { ENV['TEST_FORGEJO_TOKEN'] }
  c.filter_sensitive_data('<TEST_FORGEJO_REPOSITORY>') { ENV['TEST_FORGEJO_REPOSITORY'] }
  c.filter_sensitive_data('<TEST_FORGEJO_ENDPOINT>') { ENV['TEST_FORGEJO_ENDPOINT'] }
  c.filter_sensitive_data('<Authorization-REDACTED>') do |interaction|
    interaction.request.headers['Authorization'].try(:first)
  end
end
