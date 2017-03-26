require 'bunny'

conn = Bunny.new(automatically_recover: false)
conn.start

ch = conn.create_channel
q  = ch.queue('hello')

begin
  # コンシューマをキューに追加します（メッセージ配信を購読します）。
  puts ' [*] Waiting for messages. To exit press CTRL+C'
  q.subscribe(block: true) do |delivery_info, properties, body|
    # ch.default_exchange.publish の第一引数での指定したのがbodyで受け取れる
    puts " [x] Received #{body}"

    # cancel the consumer to exit
    # delivery_info.consumer.cancel # 一度受け取ったらやめる場合
  end
rescue Interrupt => e
  puts 'close'
  conn.close
  exit(0)
end

# メモ
# 2つのコンソールでレシーバーを実行して、send.rbを実行すると交互にメッセージを取得する。
#  rabbitmqctl list_queues これで現在のキューの数が見れる