require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = false
  c.filter_sensitive_data('<TEST_GITHUB_TOKEN>') { ENV['TEST_GITHUB_TOKEN'] }
  c.filter_sensitive_data('<TEST_GITHUB_REPOSITORY>') { ENV['TEST_GITHUB_REPOSITORY'] }
  c.filter_sensitive_data('<TEST_GITLAB_TOKEN>') { ENV['TEST_GITLAB_TOKEN'] }
  c.filter_sensitive_data('<TEST_GITLAB_REPOSITORY>') { ENV['TEST_GITLAB_REPOSITORY'] }
end
