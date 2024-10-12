# memo_app

## 概要
Sinatraを使ったシンプルなメモ管理アプリです。

## はじめに
- Debian 12.7 で動作確認しています。
- Bundlerを使いますので、事前にインストールをお願いします。

## セットアップ
1. このリポジトリをクローンします。
```
git clone https://github.com/takao0206/memo_app.git
```
2. クローンしたディレクトリに移動します。
```
cd memo_app
```
3. 必要な gem をインストールします。
```
bundle install
```
4. アプリケーションを起動します。
```
bundle exec ruby memo_app.rb
```
5. ブラウザで `http://localhost:4567` を開き、アプリを確認します。

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
