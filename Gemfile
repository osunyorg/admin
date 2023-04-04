source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

# Infrastructure
gem "activestorage-scaleway-service"#, path: "../activestorage-scaleway-service"
gem "active_storage_validations", "~> 1.0"
gem "angularjs-rails"
gem "aws-sdk-s3"
gem "bootstrap"
gem "bootsnap", ">= 1.4.4", require: false
gem "bootstrap5-kaminari-views"
gem "breadcrumbs_on_rails"
gem "bugsnag"
gem "cancancan", "3.3.0"
gem "caxlsx_rails", "~> 0.6.3"
gem "cocoon", "~> 1.2"
gem "country_select"
gem "curation"#, path: "../../arnaudlevy/curation"
gem "delayed_job_active_record"
gem "delayed_job_web"
gem "devise"
gem "devise-i18n"
gem "enum_help"
# gem "faceted_search"#, path: "../../noesya/faceted_search"
gem "faceted_search", git: "https://github.com/noesya/faceted_search.git", branch: "fix-habtm"
gem "font-awesome-sass"
gem "front_matter_parser"
gem "gdpr", "~> 1.2.5"
gem "geocoder", "~> 1.8"
gem "geo_point"
gem "gitlab"
gem "hal_openscience", "~> 0.1"
# gem "hal_openscience", path: "../hal_openscience"
gem "has_scope", "~> 0.8.0"
gem "hash_dot"
gem "image_processing"
gem "jbuilder"
gem "jquery-rails"
gem "jquery-ui-rails", "~> 6.0.1"
gem "kamifusen"#, path: "../kamifusen"
gem "kaminari"
gem "leaflet-rails"
gem "mini_magick"
gem "octokit"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "omniauth-saml", "~> 2.0"
gem "pexels", "~> 0.5.0"
gem "pg", "~> 1.1"
gem "puma"
gem "rails", "~> 7.0"
gem "rails-autocomplete", "~> 2.0"
gem "rails-i18n"
gem "roo", "~> 2.9"
gem "sanitize"
gem "sassc-rails"
# gem "scout_apm", "~> 5.1"
gem "sib-api-v3-sdk"
gem "simple-navigation"
gem "simple_form"
gem "simple_form_bs5_file_input"#, path: "../simple_form_bs5_file_input"
gem "simple_form_password_with_hints"#, path: "../simple_form_password_with_hints"
gem "sprockets-rails", "~> 3.4"
gem "summernote-rails", git: "https://github.com/noesya/summernote-rails.git"
# gem "summernote-rails", path: "../summernote-rails"
gem "two_factor_authentication", git: "https://github.com/noesya/two_factor_authentication.git"
# gem "two_factor_authentication", path: "../two_factor_authentication"
gem "unsplash"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "figaro"
  gem "vcr"
  gem "webmock"
end

group :development do
  gem "annotate"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "simplecov", require: false
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
