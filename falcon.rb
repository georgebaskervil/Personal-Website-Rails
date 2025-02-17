#!/usr/bin/env -S falcon host

load :rack

hostname = File.basename(__dir__)
port = ENV["PORT"] || 3000

rack hostname do
  append preload "preload.rb"
  endpoint Async::HTTP::Endpoint.parse("http://0.0.0.0:#{port}")
end
