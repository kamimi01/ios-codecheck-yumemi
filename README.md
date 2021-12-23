# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

本プロジェクトは[こちら](https://github.com/yumemi-inc/ios-engineer-codecheck)の課題回答のプロジェクトです。

## アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。

![動作イメージ](README_Images/app.gif)

### 環境

- IDE：Xcode 13.0
- Swift：Swift 5.5
- 開発ターゲット：iOS 15.0（15.0以降で使用可能なAPIを使用しております。）
  - 端末：iPhone13、iPhone8で動作確認済み
- ライブラリ管理：cocoapods 1.10.1

### 機能

- 検索、詳細表示（リポジトリ検索画面）
  1. 何かしらのキーワードを入力
  2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名、言語、Star 数、オーナーアイコン）で表示
  3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示

- ソート（リポジトリ検索画面）
  1. 右上の四角いボタンを押す
  2. アクションシートに選択肢が表示されるので、何かしら選択（Star 数、Watcher 数、Forks 数、Issue 数）
  3. 選択した項目に応じてリポジトリ一覧が昇順ソートされる

## 課題

- 以下、2種類の方法で課題に取り組んでいます。

|ブランチ名|概要|アーキテクチャ|UIフレームワーク|サードパーティライブラリ|
|----------|--------------|-----------|----------|------------|
|uikit|・初級/中級課題に取り組んでいます<br>（ボーナス課題は未対応）<br>**・初級/中級課題はこちらのブランチをご確認ください。**|MVP|UIKit|・Swiftlint(0.45.1) <br> ・R.swift(6.1.0)|
|main <br> develop|・UIKitを使用したプロジェクトで初級/中級課題終了後、ボーナス課題に入るタイミングでSwiftUIに全面切り替えしました。<br>**・ボーナス課題はこちらのブランチをご確認ください。**|MVVM|SwiftUII|・Swiftlint(0.45.1) <br> ※R.swiftは公式にはSwiftUIに対応していないため、未使用|

## 環境構築

### 事前条件

- cocoapodsが事前にインストール済みであること

### ビルド手順

1. プロジェクトのルートディ入れクトリで、`pod install`を実施（`uikit`ブランチとそのほかのブランチでは使用しているライブラリが異なるため、切り替えたら再度`pod install`を実行してください。）
  
## Git管理

- ブランチモデル
  - Git-flow
- コミットメッセージ
  - [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)に従う

## 残課題

- 期限内に解決しなかったこと、わからなかったことを[Issues](https://github.com/kamimi01/ios-codecheck-yumemi/issues)に残しています

## 参考記事

- [GitHubAPIドキュメント](https://docs.github.com/ja/rest/reference/search#search-repositories)
  - リポジトリ検索のAPI仕様確認のため
- [illustAC](https://www.ac-illust.com/)
  - 画像の取得に失敗した場合に表示する画像の利用のため