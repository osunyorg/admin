Kamifusen.config do |config|
  config.keycdn = "https://#{ENV['KEYCDN_HOST']}" if ENV['KEYCDN_HOST'].present?
end
