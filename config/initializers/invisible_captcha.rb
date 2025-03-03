InvisibleCaptcha.setup do |config|
  # Timestamp check enabled except in test environment
  config.timestamp_enabled = !Rails.env.test?
  # Spinner check enabled except in test environment
  config.spinner_enabled = !Rails.env.test?
end