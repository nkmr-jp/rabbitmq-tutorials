require 'bunny'

conn = Bunny.new(automatically_recover: false)
conn.start

ch = conn.create_channel
q  = ch.queue('task_queue', durable: true)

msg = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

q.publish(msg, persistent: true) # 永続的メッセージ
puts " [x] Sent #{msg}"

conn.close
