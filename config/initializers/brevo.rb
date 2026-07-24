# Setup authorization
Brevo.configure do |config|
  config.api_key['api-key'] = ENV['BREVO_API_KEY']
  config.api_key['partner-key'] = ENV['BREVO_API_KEY']
end if ENV['BREVO_API_KEY'].present?

Brevo.class_eval do
  def self.active?
    ENV['BREVO_API_KEY'].present?
  end
end

api_instance = Brevo::AccountApi.new

begin
  # Get your account information, plan and credits details
  result = api_instance.get_account
rescue Brevo::ApiError => e
  puts "Exception when calling AccountApi->get_account: #{e}"
end
