# Load the gem
require 'sib-api-v3-sdk'

# Setup authorization
SibApiV3Sdk.configure do |config|
  config.api_key['api-key'] = ENV['SEND_IN_BLUE_API_KEY']
  config.api_key['partner-key'] = ENV['SEND_IN_BLUE_API_KEY']
end

api_instance = SibApiV3Sdk::AccountApi.new

begin
  # Get your account information, plan and credits details
  result = api_instance.get_account
rescue SibApiV3Sdk::ApiError => e
  puts "Exception when calling AccountApi->get_account: #{e}"
end
