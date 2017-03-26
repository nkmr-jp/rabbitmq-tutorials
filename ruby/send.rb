require 'bunny'

# RabbitMQに接続
# デフォルトだとローカルホストに接続する
# 別のマシンの場合はホスト指定する Bunny.new(:hostname => "rabbit.local")
conn = Bunny.new(automatically_recover: false)
conn.start

ch = conn.create_channel # チャンネルを作る 
q  = ch.queue('hello') # キューの設定
ch.default_exchange.publish('hello world', routing_key: q.name) # メッセージを送る

puts " [x] Sent 'Hello World!'"

conn.close
