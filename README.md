# Ruby on Rails チュートリアルのサンプルアプリケーション

これは、次の教材で作られたサンプルアプリケーションです。
[*Ruby on Rails チュートリアル*](https://railstutorial.jp/)
（第7版）
[Michael Hartl](https://www.michaelhartl.com/) 著

## ライセンス

[Ruby on Rails チュートリアル](https://railstutorial.jp/)内にある
ソースコードはMITライセンスとBeerwareライセンスのもとで公開されています。
詳細は [LICENSE.md](LICENSE.md) をご覧ください。

## 使い方

このアプリケーションを動かす場合は、まずはリポジトリをフォークしてください。

フォークしたリポジトリで、「Code」から「Codespaces」タブに移動し、
「Create codespace on main」をクリックすると環境構築がスタートします。
Railsサーバーが立ち上がり、シンプルブラウザが表示されるまでしばらくお待ちください。

次に、データベースへのマイグレーションを実行します。

```
$ rails db:migrate
```

最後に、テストを実行してうまく動いているかどうか確認してください。

```
$ rails test
```

詳しくは、[*Ruby on Rails チュートリアル*](https://railstutorial.jp/)
を参考にしてください。

```bash
poteto@envy-new:~/sample_app$ curl -o ./app/assets/images/kitten.jpg -L https://railstutorial.jp/chapters/7.0/images/figures/kitten.jpg
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 56741  100 56741    0     0  48619      0  0:00:01  0:00:01 --:--:-- 48662

```

*shift*,ctrl, *.* でerb

```bash
rails g integration_test site_layout
 rails test: integration

```

```bash
poteto@envy-new:~/sample_app$  lsof -i :3000
COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
ruby    26729 poteto    6u  IPv4 425868      0t0  TCP *:3000 (LISTEN)
ruby    26729 poteto   12u  IPv4 612292      0t0  TCP localhost:3000->localhost:57726 (ESTABLISHED)
ruby    26729 poteto   13u  IPv4 621662      0t0  TCP localhost:3000->localhost:57740 (CLOSE_WAIT)
poteto@envy-new:~/sample_app$ kill -9 26729
poteto@envy-new:~/sample_app$  lsof -i :3000

```