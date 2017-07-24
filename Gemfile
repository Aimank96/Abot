source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'mime-types', '>= 2.6', require: 'mime/types/columnar'
gem 'rails', '~> 5.1.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'slack-notifier'
gem 'slim'
gem "twitter-bootstrap-rails"
gem 'faraday'
gem 'smart_init'
gem 'jquery-rails'
gem 'sucker_punch', '~> 2.0'
gem 'activeadmin'
gem 'braintree', "~> 2.75.0"
gem 'sprockets-es6'
gem 'gon'
gem 'rack-cors', require: 'rack/cors'
gem 'exception_notification', "~> 4.2.1"

# gem 'bcrypt', '~> 3.1.7'
group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'byebug'
  gem 'capybara', '~> 2.13.0'
  gem 'selenium-webdriver'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'derailed_benchmarks'
  gem 'rspec-rails', '~> 3.5'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

ruby '2.4.0'
