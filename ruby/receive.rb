require 'bunny'

conn = Bunny.new(automatically_recover: false)
conn.start

ch = conn.create_channel
q  = ch.queue('hello')

begin
  # メッセージの購読を申し込む
  puts ' [*] Waiting for messages. To exit press CTRL+C'
  q.subscribe(block: true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt =>
  conn.close
  exit(0)
end
