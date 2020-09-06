require './method'

while(1)
	cuurent_price = get_price
	puts cuurent_price

	buy_price = 1060000
	sell_price = 1080000
	if cuurent_price > sell_price
		puts "売ります"
		order("SELL", sell_price, 0.001)
	elsif cuurent_price < buy_price
		puts  "買います"
		order("BUY", buy_price, 0.001)
	else
		puts "何もしません"
	end
	sleep(1)
end

# 現在の価格を取得
# puts get_price

#現在の資産状況を確認
# puts get_wallet("JPY")

# 買い注文
# order('BUY','1080000','0.001')

# 売り注文
# order('SELL','1120000','0.001')

