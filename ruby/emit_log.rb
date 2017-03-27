#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(:automatically_recover => false)
conn.start

ch   = conn.create_channel
x    = ch.fanout("logs") # エクスチェンジを定義


msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg) # さっきはch.default_exchangeだった。
puts " [x] Sent #{msg}"

conn.close

# 交換を宣言しました。このステップは、存在しないエクスチェンジへのパブリケーションが禁止されているため必要です。
# まだキューがExchangeにバインドされていない場合はメッセージは失われますが、それは問題ありません。
# 消費者がまだ聞いていない場合は、メッセージを安全に破棄することができます。

