# memo_app

## 概要
Sinatraを使ったシンプルなメモ管理アプリです。

## はじめに
- Debian 12.7 で動作確認しています。
- Bundlerを使いますので、事前にインストールをお願いします。
- データベースはPostgresSQL 16.4を使いますので、事前にインストールをお願いします。

## セットアップ
1. このリポジトリをクローンします。
  ```bash
  git clone https://github.com/takao0206/memo_app.git
  ```
  もし開発用のブランチ (develop) をクローンしたい場合は、以下を実行します。
  ```bash
  git clone -b develop https://github.com/takao0206/memo_app.git
  ```
2. クローンしたディレクトリに移動します。
  ```bash
  cd memo_app
  ```
3. 必要な gem をインストールします。
  ```bash
  bundle install
  ```
4. ルートディレクトリに`.env`ファイルを作成し、Postgresに作成すデータベース名、接続するユーザ、パスワードを記入します。
フォーマットは、ルートディレクトにある`env.example`を参考にして下さい。

5. `.env`に書いたデータベースとユーザをPostgresに作成して下さい。

以下、Postgresで行うデータベース（`memo_app`）とユーザ (`memo_app_user`) の作成の例です。
  1. Postgresにログインします (ここで`postgres`は管理者ユーザーの名前です) 。
  ```bash
  psql -U postgres
  ```
  2. `memo_app_user`というユーザーを作成し、`CreateDB`の権限を付与します。
  ```
  CREATE USER memo_app_user WITH PASSWORD 'memo_app_password';
  ALTER USER memo_app_user CREATEDB;
  ```
  3. `memo_app_user`がオーナーのデータベース`memo_app`を作成します。
  ```
  CREATE DATABASE memo_app WITH OWNER memo_app_user;
  ```
  これで、`memo_app_user`というユーザーがオーナーのデータベース`memo_app`が作成されました。

6. アプリケーションを起動します。
  ```bash
  bundle exec ruby memo_app.rb
  ```
7. ブラウザで `http://localhost:4567` を開き、アプリを確認します。

## 機能
- メモ一覧表示
- メモの作成
- メモの編集
- メモの削除

## 使用技術
- Sinatra : Ruby の Web アプリケーションフレームワーク
- JSON : メモのデータ管理に使用
- HTML/ERB : テンプレートエンジンを使ったビュー
- JavaScript/CSS : フロントエンドの動作とデザイン
- PostgreSQL : データ保存
