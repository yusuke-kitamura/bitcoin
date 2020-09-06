require './method'

while(1)
	cuurent_price = get_price
	puts cuurent_price

	buy_price = 1060000
	sell_price = 1080000
	if (cuurent_price > sell_price) && (get_wallet("BTC")["amount"] > 0.001)
		puts "売ります"
		order("SELL", sell_price, 0.001)
	elsif cuurent_price < buy_price && (get_wallet("JPY")["amount"] > 1000)
		puts  "買います"
		order("BUY", buy_price, 0.001)
	else
		puts "何もしません"
	end
	sleep(1)
end