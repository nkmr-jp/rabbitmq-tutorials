require 'bunny'

conn = Bunny.new(automatically_recover: false)
conn.start

ch = conn.create_channel
q  = ch.queue('task_queue', durable: true) # 耐久性のあるキュー

# prefetchは basic_qosのalias
# @param [Integer] prefetch_count このチャネル上のコンシューマは一度にいくつのメッセージを与えることができますか。 
# （以前に受信したメッセージの1つを確認または拒否する前に）
ch.prefetch(1) 
puts ' [*] Waiting for messages. To exit press CTRL+C'

begin
  # ＃@option opts [Boolean]：manual_ack（false）このコンシューマは手動承認を使用しますか？
  # @option opts [Boolean] :manual_ack (false) Will this consumer use manual acknowledgements?
  q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    puts " [x] Received '#{body}'"
    # imitate some work
    sleep body.count('.').to_i
    puts ' [x] Done'
    ch.ack(delivery_info.delivery_tag) # ここで手動承認している
  end
rescue Interrupt => _
  conn.close
end

# デフォルトでは、RabbitMQは各メッセージを次のコンシューマに順番に送信します。
# 平均して、すべての消費者は同じ数のメッセージを取得します。
# メッセージを配信するこの方法は、ラウンドロビンと呼ばれます。

# rabbitmqctl list_queues name messages_ready messages_unacknowledged
# これで、承認されたメッセージと、されてないメッセージをみれる。
# それは欠場するよくある間違いだACKを。
# それは簡単なエラーですが、結果は深刻です。
# クライアントが終了すると（ランダム再配信のように見えるかもしれませんが）メッセージは再配信されますが、
# RabbitMQは未送信メッセージを解放できないため、より多くのメモリを消費します。