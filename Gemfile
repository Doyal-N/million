source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'webpacker', '~> 5.0'
gem 'puma'
gem 'dotenv-rails'
gem 'devise'
gem 'pg', '~> 1.1'
gem 'rails-i18n'
gem 'rails_admin'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
end

group :test do
  gem 'shoulda-matchers', '~> 4.5.1'
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'database_cleaner-active_record'
end

group :development do
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
