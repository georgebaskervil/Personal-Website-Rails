class RequestCounter
  # Use class instance variables instead of class variables for thread safety
  @mutex = Mutex.new
  @pending_count = 0
  @last_sync = Time.current
  @sync_interval = 30.seconds # Sync every 30 seconds
  @batch_size = 50 # Or sync every 50 requests

  class << self
    attr_accessor :mutex, :pending_count, :last_sync, :sync_interval, :batch_size

    def increment_memory_counter
      @mutex.synchronize do
        @pending_count += 1

        # Check if we should sync to database (either by time or count threshold)
        should_sync = (Time.current - @last_sync) >= @sync_interval ||
                      @pending_count >= @batch_size

        sync_to_database_async if should_sync
      end
    rescue StandardError => e
      # Don't let counter errors break requests
      Rails.logger.error "RequestCounter: Failed to increment memory counter: #{e.message}"
    end

    def sync_to_database_async
      # Get the current pending count and reset it
      count_to_sync = @pending_count
      @pending_count = 0
      @last_sync = Time.current

      # Sync in a background thread to avoid blocking the request
      Thread.new do
        sync_to_database(count_to_sync)
      end
    end

    def sync_to_database(count = nil)
      return if count&.zero?

      @mutex.synchronize do
        # If no specific count provided, use whatever is pending
        if count.nil?
          count = @pending_count
          @pending_count = 0
          @last_sync = Time.current
        end

        return if count.zero?

        # Use atomic SQL update to avoid race conditions
        HttpReqCounter.connection.execute(
          HttpReqCounter.sanitize_sql_array([
                                              "UPDATE http_req_counters SET count = count + ? WHERE id = (SELECT id FROM http_req_counters LIMIT 1)",
                                              count
                                            ])
        )

        # If no record exists, create one
        HttpReqCounter.create!(count: count) if HttpReqCounter.count.zero?
      end
    rescue StandardError => e
      Rails.logger.error "RequestCounter: Failed to sync to database: #{e.message}"
      # Put the count back if sync failed
      @mutex.synchronize { @pending_count += count } if count
    end

    # Method to get current total count (database + pending)
    def current_count
      @mutex.synchronize do
        db_count = HttpReqCounter.first&.count || 0
        db_count + @pending_count
      end
    rescue StandardError => e
      Rails.logger.error "RequestCounter: Failed to get current count: #{e.message}"
      0
    end

    # Ensure we sync on application shutdown
    def finalize_counter
      sync_to_database
    end
  end
end

# Ensure we sync on application shutdown
at_exit { RequestCounter.finalize_counter }
