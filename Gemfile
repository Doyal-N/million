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

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', '~> 4.5.1'
  gem 'capybara'
  gem 'launchy'
end

group :development do
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
