Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_RUBY_KEY']
  config.release_stage = ENV['APPLICATION_ENV']
  config.notify_release_stages = ['production', 'staging']
  config.meta_data_filters += ['default_github_access_token', 'access_token', 'sso_cert']

  config.add_on_error(proc do |event|
    next unless event.metadata.key?(:active_job)
    job_name = event.metadata.dig(:active_job, :job_name)
    next unless job_name == "ActiveStorage::AnalyzeJob"
    ignored_error_classes = [
      "ActiveStorage::FileNotFoundError",
      "Aws::S3::Errors::NoSuchKey",
      "Aws::S3::Errors::NotFound",
      "MiniMagick::Error"
    ]
    error_class = event.exceptions.first[:errorClass]
    next unless ignored_error_classes.include?(error_class)
    false
  end)
end
