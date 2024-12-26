source "https://rubygems.org"

ruby "3.3.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use SQLite 3 as the database for Active Record
gem "sqlite3"

# Use the falcon web server
gem "falcon"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Compress responses more effectively
gem "rack-brotli"

# Use the kramdown markdown parser
gem "kramdown"

# HTML compressor to minify HTML when sent to the client
gem "htmlcompressor", "~> 0.4.0"

# CSS Bundler to use PostCSS
gem "cssbundling-rails"

# Rack-attack to rate-limit HTTP endpoints
gem "rack-attack"

# sentry sdk to use glitchtip
gem "sentry-ruby"
gem "sentry-rails"

# Use nokogiri to parse HTML
gem "nokogiri"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use unicode gem for emoji support
gem "unicode"

# Use solid_cache to cache in sqlite
gem "solid_cache"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Make the code actually look good
  gem "rubocop-rails-omakase"

  # Lint ERB files
  gem "erb_lint"

  # Use the erb formatter to format ERB files
  gem "erb-formatter", "~> 0.7.3"

  # fly.io's dockerfile generator to generate a docker compose file for the site.
  gem "dockerfile-rails", ">= 1.6"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
