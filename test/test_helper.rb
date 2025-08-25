require 'simplecov'
require 'simplecov_json_formatter'

SimpleCov.start 'rails' do
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::JSONFormatter,
    SimpleCov::Formatter::HTMLFormatter
  ])
end

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
    try(:host!, default_university.host)
  end

  def default_university
    @default_university ||= universities(:default_university)
  end

  def french
    @french ||= languages(:fr)
  end

  def english
    @english ||= languages(:en)
  end

  def default_extranet
    @default_extranet ||= communication_extranets(:default_extranet)
  end

  def website_with_github
    @website_with_github ||= communication_websites(:website_with_github)
  end

  def website_with_gitlab
    @website_with_gitlab ||= communication_websites(:website_with_gitlab)
  end

  def default_school
    @default_school ||= education_schools(:default_school)
  end

  def alumnus
    @alumnus ||= users(:alumnus)
  end

  def alumnus_person
    @alumnus_person ||= university_people(:alumnus)
  end

  def olivia
    @olivia ||= university_people(:olivia)
  end

  def pa
    @pa ||= university_people(:pa)
  end

  def arnaud
    @arnaud ||= university_people(:arnaud)
  end

  def noesya
    @noesya ||= university_organizations(:noesya)
  end

  def admin
    @admin ||= users(:admin)
  end

  def server_admin
    @server_admin ||= users(:server_admin)
  end
end
