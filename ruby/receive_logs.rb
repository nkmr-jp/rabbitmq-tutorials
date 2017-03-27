#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(:automatically_recover => false)
conn.start

ch  = conn.create_channel
x   = ch.fanout("logs") # エクスチェンジを定義
q   = ch.queue("", :exclusive => true) #キューを定義

q.bind(x) # これからlogsエクスチェンジによってメッセージがキューに追加されます。

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] #{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close

  exit(0)
end


# エクスチェンジとキューとの関係をバインディングといいます。
# rabbitmqctl list_exchanges エクスチェンジリストみれる
# rabbitmqctl list_bindings バインディングリストみれる