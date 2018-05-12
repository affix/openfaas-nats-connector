require "nats/client"

NATS.start do
  NATS.publish('function.call', {function: 'figlet', params: {callback_url: 'http://your-callback.url/example', body: 'Hello World'}}.to_json) { NATS.stop}
end
