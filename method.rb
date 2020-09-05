require 'net/http'
require 'uri'
require 'json'
require './key.rb'

# 板情報を取得
uri = URI.parse("https://api.bitflyer.com")
uri.path = '/v1/getboard'
uri.query = ''

# データを取得
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
response = https.get uri.request_uri

response_hash = JSON.parse(response.body)
puts response_hash["mid_price"]