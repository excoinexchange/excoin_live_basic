require 'faye'
require 'eventmachine'
require 'json'

LIVE_API_KEY = "LIVE-API-KEY"

EM.run do
  p "Attempting live connection to Excoin..."

  client = Faye::Client.new('https://live.exco.in/v1/')

  client.bind('transport:up') do
    p "Successfully connected to Excoin Live API."
  end

  client.bind('transport:down') do
    p "Disconnected from Excoin Live API, attempting reconnect..."
  end

  client.subscribe("/chat") do |message|
    chat_message = JSON.parse(message)
    p chat_message
  end

  client.subscribe("/account/#{LIVE_API_KEY}") do |message|
    account_update = JSON.parse(message)
    p account_update
  end

  client.subscribe("/summary") do |message|
    exchange_update = JSON.parse(message)
    p exchange_update
  end

  # Specify the exchange
  client.subscribe("/exchange/BTC/BLK") do |message|
    exchange_order_update = JSON.parse(message)
    p exchange_order_update
  end
end
