source "https://rubygems.org"

ruby "3.4.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "8.0.1"

# Use vite rails instead of the regular
gem "vite_rails"

# Use SQLite 3 as the database for Active Record
gem "sqlite3"

# Use the falcon web server
gem "falcon"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Compress responses more effectively
gem "rack-brotli"

# Use the kramdown markdown parser
gem "kramdown"

# HTML compressor to minify HTML when sent to the client
gem "htmlcompressor"

# Rack-attack to rate-limit HTTP endpoints
gem "rack-attack"

# sentry sdk to use glitchtip
gem "sentry-rails"
gem "sentry-ruby"

# Use nokogiri to parse HTML
gem "nokogiri"

# Use unicode gem for emoji support
gem "unicode"

# Install tzinfo-data everywhere to avoid platforms specific bugs
gem "tzinfo-data"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap"

# Use the better_html gem to validate resultant HTML
gem "better_html"

# Use turbo-mount to allow me to use components written in conventional js frameworks here
gem "turbo-mount"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Make the code actually look good
  gem "rubocop"
  gem "rubocop-rails"

  # Lint ERB files
  gem "erb_lint"

  # Use the erb formatter to format ERB files
  gem "erb-formatter"

  # fly.io's dockerfile generator to generate a docker compose file for the site.
  gem "dockerfile-rails"

  # Use fasterer for speed improvement hints
  gem "fasterer"

  # Use the brakeman gem to check for security vulnerabilities
  gem "brakeman"

  # foreman does not seem to be installed by rails automatically
  gem "foreman"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
