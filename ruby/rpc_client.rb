#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require "thread"

conn = Bunny.new(:automatically_recover => false)
conn.start

ch   = conn.create_channel


class FibonacciClient
  attr_reader :reply_queue
  attr_accessor :response, :call_id
  attr_reader :lock, :condition

  def initialize(ch, server_queue)
    @ch             = ch
    @x              = ch.default_exchange

    @server_queue   = server_queue
    @reply_queue    = ch.queue("", :exclusive => true) #匿名の排他コールバックキュー


    @lock      = Mutex.new
    @condition = ConditionVariable.new
    that       = self

    # 戻りの一時キューを購読する。
    @reply_queue.subscribe do |delivery_info, properties, payload|
      if properties[:correlation_id] == that.call_id
        that.response = payload.to_i
        that.lock.synchronize{that.condition.signal}
      end
    end
  end

  def call(n)
    self.call_id = self.generate_uuid #ランダムなIDを発行している

    @x.publish(n.to_s,
      :routing_key    => @server_queue,      # rpc_queue というキュー名がルーティングキーとなる。
      :correlation_id => call_id,            #一時的につかうランダムなID
      :reply_to       => @reply_queue.name)  #これが匿名キュー？テンポラリ？ワーカー(サーバー)はこのキューを使ってジョブが終わったとメッセージをかえす。

    lock.synchronize{condition.wait(lock)}
    response
  end

  protected

  def generate_uuid
    # very naive but good enough for code
    # examples
    "#{rand}#{rand}#{rand}"
  end
end


client   = FibonacciClient.new(ch, "rpc_queue")
puts " [x] Requesting fib(30)"
response = client.call(30)
puts " [.] Got #{response}"

ch.close
conn.close

# で第二のチュートリアル、私たちは、使用する方法を学びました作業キューを複数の労働者の間で時間のかかるタスクを分散します。
# しかし、リモートコンピュータ上で関数を実行し、その結果を待つ必要がある場合はどうすればよいでしょうか？まあ、それは別の話です。
# このパターンは、一般にリモートプロシージャコールまたはRPCと呼ばれます。
# このチュートリアルでは、RabbitMQを使用してRPCシステムを構築します。
# クライアントとスケーラブルなRPCサーバーです。
# 配布に時間を費やす作業がないので、フィボナッチ数を返すダミーRPCサービスを作成します。

# ：persistent：メッセージを永続的（trueの値）または一時的（false）としてマークします。
#     2番目のチュートリアルからこのプロパティを覚えているかもしれません。
# ：content_type：エンコーディングのMIMEタイプを記述するために使用されます。
#     たとえば、頻繁に使用されるJSONエンコーディングの場合、このプロパティをapplication / jsonに設定することをお勧めします。
# ：reply_to：コールバックキューに名前を付けるためによく使用されます。
# ：correlation_id：RPC応答を要求と相関させるのに便利です。
