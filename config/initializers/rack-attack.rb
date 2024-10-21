class Rack::Attack

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  throttle('req/ip', limit: 120, period: 5.minutes) do |req|
    req.ip
  end

  self.throttled_responder = lambda do |request|
    [
      429,
      {'Content-Type' => 'text/plain', 'Retry-After' => '300'},
      ['I have throttled your traffic because you sent too many requests. Please try again in one minute.']
    ]
  end

end