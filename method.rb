require 'net/http'
require 'uri'
require 'json'
require './key.rb'
require "openssl"

# 現在の価格を取得
def get_price
	# 板情報を取得
	uri = URI.parse("https://api.bitflyer.com")
	uri.path = '/v1/getboard'
	uri.query = ''

	# データを取得
	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	response = https.get uri.request_uri

	response_hash = JSON.parse(response.body)
	response_hash["mid_price"]
end

# 売買、値段、取引量をorderの引数として指定
def order(side,price,size)
	key = API_KEY
	secret = API_SECRET

	timestamp = Time.now.to_i.to_s
	method = "POST"
	uri = URI.parse("https://api.bitflyer.com")
	uri.path = "/v1/me/sendchildorder"
	# 買い取引の際の詳細情報を指定
	body = '{
	  "product_code": "BTC_JPY",
	  "child_order_type": "LIMIT",
	  "side":"' + side + '",
	  "price":' + price + ',
	  "size":' + size + ',
	  "minute_to_expire": 10000,
	  "time_in_force": "GTC"
	}'

	text = timestamp + method + uri.request_uri + body
	sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

	options = Net::HTTP::Post.new(uri.request_uri, initheader = {
	  "ACCESS-KEY" => key,
	  "ACCESS-TIMESTAMP" => timestamp,
	  "ACCESS-SIGN" => sign,
	  "Content-Type" => "application/json"
	});
	options.body = body

	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	response = https.request(options)
	puts response.body
end

# 現在の資産状況を取得
def get_wallet(coin_name)
	key = API_KEY
	secret = API_SECRET

	timestamp = Time.now.to_i.to_s
	method = "GET"
	uri = URI.parse("https://api.bitflyer.com")
	uri.path = "/v1/me/getbalance"

	text = timestamp + method + uri.request_uri
	sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

	options = Net::HTTP::Get.new(uri.request_uri, initheader = {
	  "ACCESS-KEY" => key,
	  "ACCESS-TIMESTAMP" => timestamp,
	  "ACCESS-SIGN" => sign,
	});

	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	response = https.request(options)
	response_hash = JSON.parse(response.body)
	response_hash.find {|n| n["currency_code"] === coin_name}
end

def ifdoneOCO
	key = API_KEY
	secret = API_SECRET

	timestamp = Time.now.to_i.to_s
	method = "POST"
	uri = URI.parse("https://api.bitflyer.com")
	uri.path = "/v1/me/sendparentorder"
	body = '{
	  "order_method": "IFDOCO",
	  "minute_to_expire": 10000,
	  "time_in_force": "GTC",
	  "parameters": [{
	    "product_code": "BTC_JPY",
	    "condition_type": "LIMIT",
	    "side": "BUY",
	    "price": 30000,
	    "size": 0.1
	  },
	  {
	    "product_code": "BTC_JPY",
	    "condition_type": "LIMIT",
	    "side": "SELL",
	    "price": 32000,
	    "size": 0.1
	  },
	  {
	    "product_code": "BTC_JPY",
	    "condition_type": "STOP_LIMIT",
	    "side": "SELL",
	    "price": 28800,
	    "trigger_price": 29000,
	    "size": 0.1
	  }]
	}'

	text = timestamp + method + uri.request_uri + body
	sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

	options = Net::HTTP::Post.new(uri.request_uri, initheader = {
	  "ACCESS-KEY" => key,
	  "ACCESS-TIMESTAMP" => timestamp,
	  "ACCESS-SIGN" => sign,
	  "Content-Type" => "application/json"
	});
	options.body = body

	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	response = https.request(options)
	puts response.body
end