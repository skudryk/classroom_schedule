source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

# Rails core
gem "rails", "~> 7.1.0"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"

# API specific CORS
gem "rack-cors"

# for authentication
gem "jwt"
gem 'simple_command'

# for PDF generation
gem "prawn"

# Background jobs
gem "sidekiq"

gem "concurrent-ruby", "~> 1.3.4"

# Development and test gems
group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
end
