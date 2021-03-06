# README

## 概要
DDD(Domain Driven Design)をrailsで練習として実装するリポジトリになります。

`app/domain_models/domain`がドメインロジックの実装箇所です。

どのようにドメインロジックが使用されるかについては、以下を見ていただけるとわかると思います。

- `spec/domain_models/domain`配下のテスト
- GUIのエントリーポイントである`app/controllers/debug/people_controller.rb#root`から辿れるページのロジック

## 起動方法
```
docker-compose up
```
※注記にあるようエラーになるページもありますのでご了承ください。

## 注記
- DDD実装について
  - ドメインモデルの配置場所
    - `spec/domain_models/domain`
      - 変な命名ですがautoloadしたクラスにドメイン用の名前空間（Domain）をつけたかったためにこのようなディレクトリ構成になっています
        - 付けないと`app/models`配下のActiveModelと命名がかぶるための苦渋の決断です。
        - このような無理矢理の運用をせずとも、以下の方法もあったと今は後悔しています。
          - ActiveModelをドメインモデルとする
          - `app/models/domain`をドメインモデルのディレクトリにする
          - `app/lib/domain`をドメインモデルのディレクトリにする
  - 「~サービス」(ドメインサービス・アプリケーションサービス)の運用方法について
    - 「~サービス」という言葉は使用せず、CQRSに則り参照系と更新系を分離し、参照系に「Finder」更新系に「Command」という命名をしています。
      - 「~サービス」という言葉が多義的で人によって理解のされ方が変わってしまうと思ったため改名
      - いわゆる「~サービス」(このリポジトリ上のFinder,Command)は、サービスクラスとして用いており、1ファイル1処理のみを記載しています。
- Railsの基本的なディレクトリについての使用方法
  - ActiveRecord
    - 単なるDAOとして使用しています。
  - ページ(controller, view)
    - 今回はロジックのみに集中して作成したため、ページはデバッグ用の便利なGUI、ドメインモデルが使われても問題なく作動するかどうかの検証としてのみしか機能していません。
    - レコードがないとエラーになるview用ロジックが多数あるので、viewを見るときは雰囲気を知る程度しかできないことをご了承ください。