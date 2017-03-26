# Ruby code for RabbitMQ tutorials

Here you can find Ruby code examples from
[RabbitMQ tutorials](http://www.rabbitmq.com/getstarted.html).

## Requirements

To run this code you need [Bunny](http://rubybunny.info).

You can install it via RubyGems:

    gem install bunny --version ">= 2.5.1"

Bunny supports Ruby 2.0 and later versions.

## Code

[Tutorial one: "Hello World!"](http://www.rabbitmq.com/tutorial-one-ruby.html):

    ruby send.rb
    ruby receive.rb

[Tutorial two: Work Queues](http://www.rabbitmq.com/tutorial-two-ruby.html):

    ruby new_task.rb
    ruby worker.rb

[Tutorial three: Publish/Subscribe](http://www.rabbitmq.com/tutorial-three-ruby.html)

    ruby receive_logs.rb
    ruby emit_log.rb

[Tutorial four: Routing](http://www.rabbitmq.com/tutorial-four-ruby.html)

    ruby receive_logs_direct.rb
    ruby emit_log_direct.rb

[Tutorial five: Topics](http://www.rabbitmq.com/tutorial-five-ruby.html)

    ruby receive_logs_topic.rb
    ruby emit_log_topic.rb

[Tutorial six: RPC](http://www.rabbitmq.com/tutorial-six-ruby.html)

    ruby rpc_server.rb
    ruby rpc_client.rb

To learn more, visit [Bunny documentation](http://rubybunny.info) site.


***


> RabbitMQはメッセージブローカーです。
主なアイデアはかなりシンプルです。
メッセージを受け入れて転送します。
あなたはそれを郵便局と考えることができます。
郵便箱にメールを送るとき、郵便配達員が最終的にあなたの受取人に郵便物を届けてくれると確信しています。
このメタファーを使うとRabbitMQはポストボックス、郵便局、郵便配達員です。

らしい。Google翻訳使えば読めます。

https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html


***

先にRabbitMQをインストールしておく。
Macの場合はbrewでOK。

```
brew install rabbitmq #インストール
rabbitmq-server #起動
rabbitmqctl status #ステータスを見る
rabbitmq-plugins enable rabbitmq_management #管理画面を有効にする
open http://localhost:15672 #管理画面を開く guest/guest でログイン
```

