require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PersonalWebsiteRailsWebpack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
     # Configure the asset pipeline
     config.assets.enabled = true

     # Disable GZIP compression for assets
     config.assets.gzip = false
 
     # Disable fingerprinting (asset digest)
     config.assets.digest = true
 
     # Specify additional paths where Rails should look for assets
     config.assets.paths << Rails.root.join('app', 'assets', '88x31')
     config.assets.paths << Rails.root.join('app', 'assets', 'icons')
     config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
     config.assets.paths << Rails.root.join('app', 'assets', 'images')
     config.assets.paths << Rails.root.join('app', 'assets', 'builds')
     config.assets.paths << Rails.root.join('app', 'assets', 'articles')
     config.assets.paths << Rails.root.join('app', 'assets', 'photos')
     config.assets.paths << Rails.root.join('app', 'assets', 'emoji')
     config.assets.paths << Rails.root.join('app', 'assets', 'losslessphotos')
     config.assets.paths << Rails.root.join('app', 'assets', 'videos')
     config.assets.paths << Rails.root.join('app', 'assets', 'files')
 
     # Precompile additional assets. 
     config.assets.precompile += %w( *.png *.JPG *.gif *.svg *.eot *.woff *.woff2 *.ttf *.md *.css *.js *.jsdos *.wasm *.webp *.avif *.jxl *.m3u8 *.ts)
  end
end
