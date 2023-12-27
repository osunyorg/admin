# frozen_string_literal: true

LibreTranslate.configure do |config|
  # Configure the base URL of your LibreTranslate provider.
  config.base_url = ENV.fetch("LIBRETRANSLATE_BASE_URL", "https://libretranslate.com")

  # Configure the API key that will be used in requests.
  config.api_key = ENV["LIBRETRANSLATE_API_KEY"]
end