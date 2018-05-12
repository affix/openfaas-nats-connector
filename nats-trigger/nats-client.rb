#!/usr/bin/env ruby

require 'nats/client'
require 'httparty'

opts = {
  :dont_randomize_servers => true,
  :reconnect_time_wait => 0.5,
  :max_reconnect_attempts => 10,
  :servers => [ENV['NATS_HOST']]
}

NATS.start do
  NATS.connect(opts) do
    NATS.subscribe('function.call', :queue => 'functions') do |msg|
      msg = JSON.parse(msg)
      async = msg['params']['callback_url'] ? true : false
      gateway = ENV['FAAS_GATEWAY'] || 'http://gateway:8080'
      puts "triggering '#{msg['function']}' #{async ? 'Asynchronous' : 'Synchronous'}"
      headers = {}
      base_url = "http://#{gateway}/function/"
      if async
        headers = {'X-Callback-Url': msg['params']['callback_url']}
        base_url = "http://#{gateway}/async-function/"
      end

      puts HTTParty.post(
        "#{base_url}#{msg['function']}",
         body: msg['params']['body'],
        headers: headers
      )
    end
  end
end

