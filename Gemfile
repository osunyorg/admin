source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Infrastructure
gem 'pg', '~> 1.1'
gem 'aws-sdk-s3'
gem 'puma'
gem 'image_processing'
gem 'mini_magick'
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bugsnag'
gem 'sib-api-v3-sdk'
gem 'gdpr'

# Back
gem 'rails'
gem 'rails-i18n'
gem 'devise'
gem 'devise-i18n'
gem 'cancancan'
gem 'simple_form'
gem 'simple_form_password_with_hints'#, path: '../simple_form_password_with_hints'
gem 'simple_form_bs5_file_input'#, path: '../simple_form_bs5_file_input'
gem 'enum_help'
gem 'country_select'
gem 'breadcrumbs_on_rails'
gem 'simple-navigation'
gem 'kaminari'
gem 'bootstrap5-kaminari-views'
gem 'octokit'
gem 'front_matter_parser'
gem 'two_factor_authentication', git: 'https://github.com/noesya/two_factor_authentication.git'
# gem 'two_factor_authentication', path: '../two_factor_authentication'
gem 'curation'#, path: '../../arnaudlevy/curation'
gem 'cocoon', '~> 1.2'
gem 'has_scope', '~> 0.8.0'

# Front
gem 'jquery-rails'
gem 'sassc-rails'
gem 'jbuilder'
gem 'kamifusen'#, path: '../kamifusen'
gem 'bootstrap'
gem 'sanitize'
gem 'summernote-rails', git: 'https://github.com/noesya/summernote-rails.git'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'figaro'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'annotate'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
