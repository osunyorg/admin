require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

Dir["./test/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  include TwoFactorAuthentication::Test::IntegrationHelpers

  fixtures :all

  setup do
    ENV.update(ENV.to_h.merge('APPLICATION_ENV' => 'test'))
    host! "my-university#{University.test_domain}"
  end

  def alumnus
    @alumnus ||= users(:alumnus)
  end

  def alumnus_person
    @alumnus_person ||= university_people(:alumnus)
  end

  def admin
    @admin ||= users(:admin)
  end

  def server_admin
    @server_admin ||= users(:server_admin)
  end
end
