# Iodine configuration for production and development
require "etc"

if defined?(Iodine)
  # Set number of threads to max available CPU cores for concurrency
  Iodine.threads = Etc.nprocessors if Iodine.threads.zero?

  # Set number of worker processes for max concurrency
  if Rails.env.production?
    # In production, use CPU core count for workers to maximize concurrency
    Iodine.workers = Etc.nprocessors if Iodine.workers.zero?
  elsif Iodine.workers.zero?
    # Single worker for development to avoid issues with code reloading
    Iodine.workers = 1
  end

  # Set the port: 3000 for production, 3001 for development
  default_port = Rails.env.production? ? 3000 : 3001
  Iodine::DEFAULT_SETTINGS[:port] = default_port
end
