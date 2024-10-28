# memo_app

## 概要
Sinatraを使用したシンプルなメモ管理アプリです。

## 動作環境
- **OS**: Debian 12.7で動作確認済み
- **必須ツール**: Bundler（事前にインストールが必要）
- **データベース**: PostgreSQL 16.4を使用（事前にインストールが必要）

## セットアップ手順

1. **リポジトリをクローン**
```bash
git clone https://github.com/takao0206/memo_app.git
```
開発用ブランチ（`develop`）をクローンしたい場合:
```bash
git clone -b develop https://github.com/takao0206/memo_app.git
```
2. **ディレクトリに移動**
```bash
cd memo_app
```
3. **必要なgemをインストール**
```bash
bundle install
```
4. **`.env`ファイルを作成**
ルートディレクトリに`.env`ファイルを作成し、PostgreSQL用のデータベース名、ユーザー、パスワードを設定します。
`env.example`ファイルを参考にフォーマットを記入します。
例えば、データベース名が`memo_app`、ユーザー名が`memo_app_user`、パスワードが`memo_app_password`の場合、以下のようになります。
```bash
DATABASE_NAME=memo_app
DATABASE_USER=memo_app_user
DATABASE_PASSWORD=memo_app_password
```
5. **PostgreSQLにデータベースとユーザを作成**
以下は`memo_app`というデータベースと`memo_app_user`というユーザ (パスワード: `memo_app_password`) の作成手順です。

6. **PostgreSQLにログイン**
ここで`postgres`は管理者ユーザーの名前です。
```bash
psql -U postgres
```
7. **ユーザ作成と権限付与**
```sql
CREATE USER memo_app_user WITH PASSWORD 'memo_app_password';
ALTER USER memo_app_user CREATEDB;
```
8. **データベース作成**
```sql
CREATE DATABASE memo_app WITH OWNER memo_app_user ENCODING 'UTF8' TEMPLATE template0;
```
9. **アプリケーションの起動**
```bash
bundle exec ruby memo_app.rb
```
10. **ブラウザで確認**
`http://localhost:4567` を開き、アプリを確認します。

## 機能
- メモ一覧表示
- メモの作成
- メモの編集
- メモの削除

## 使用技術
- **Sinatra:** 軽量なRuby Webフレームワーク
- **PostgreSQL:** メモデータの管理
- **HTML/ERB:** ビューのテンプレートエンジン
- **JavaScript/CSS:** フロントエンドの動作とデザイン