require "nats/client"

NATS.start do
  NATS.publish('function.call', {function: 'figlet', params: {body: 'Hello World'}}.to_json) { NATS.stop }
end
