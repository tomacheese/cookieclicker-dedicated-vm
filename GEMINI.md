# Gemini CLI Instructions

## 目的
このドキュメントは、Gemini CLI エージェントがこのリポジトリ（Cookie Clicker Dedicated VM）を扱う際のコンテキストと作業方針を定義したものです。

## 出力スタイル
- **言語**: 最終的なユーザーへの回答は日本語で行ってください。途中経過は、コンテキスト削減のため主要・重要なところ以外は英語で説明します。
- **トーン**: 専門的かつ簡潔に。
- **形式**: Markdown。

## 共通ルール
- **会話言語**: 日本語
- **コード内コメント**: 日本語で記載してください。
- **エラーメッセージ**: 原則英語で記載します。既存のエラーメッセージで先頭に絵文字がある場合は、それに倣ってください。
- **日本語と英数字の間**: 半角スペースを挿入しなければなりません。
- **コミットメッセージ**: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) に従わなければなりません。
  - `<type>(<scope>): <description>` 形式
  - `<description>` は日本語で記載
- **ブランチ命名**: [Conventional Branch](https://conventional-branch.github.io) に従わなければなりません。
  - `<type>/<description>` 形式
  - `<type>` は短縮形（feat, fix）を使用

## プロジェクト概要
- **目的**: Steam 版 Cookie Clicker を専用 VM で自動実行・管理する。
- **主な機能**:
  - 他のゲームプレイ中の Cookie Clicker 自動終了・再起動。
  - Chrome リモートデスクトップ接続時のウィンドウ自動最小化。
  - Steam オンライン状態の監視。

## コーディング規約
- **言語**: PowerShell, Batch
- **フォーマット**: 既存のコードスタイル（インデント、命名規則）に従う。
- **ドキュメント**: 関数や複雑なロジックには、docstring (またはコメント) を日本語で記載・更新してください。

## 開発コマンド
このプロジェクトは PowerShell スクリプト集であり、`package.json` によるビルドプロセスはありません。
以下のスクリプトを直接実行します。

- **メイン監視スクリプト**: `checkInGame.bat` (内部で `checkInGame.ps1` を実行)
- **ウィンドウ最小化**: `chromerdp-clicker-minimalize.ps1`
- **Steam 最小化**: `minimalize-steam.ps1`

## 注意事項
- **認証情報**: `$steam_username` などの設定値はユーザー環境に依存するため、変更する際はユーザーに確認するか、設定方法を案内する。API キーや個人的な ID などをコミットしないこと。
- **機密情報**: ログへの機密情報出力禁止。
- **Windows 環境**: これらのスクリプトは Windows (PowerShell 7+) 環境かつ Windows API (`user32.dll`) が利用可能な環境での動作を前提としている。Linux 環境の Gemini CLI から操作する場合は、WSL や Windows VM、リモート PowerShell などを用いて Windows 環境に接続し、その上で `pwsh -Command ...` を実行すること。
- **タスクスケジューラ**: `checkInGame.bat` は無限ループするため、タスクスケジューラでは「1回のみ実行」として設定する必要がある。

## リポジトリ固有
- `checkInGame.ps1` の `$steam_username` はユーザーの Steam Community Custom URL ID に設定する必要がある。
- テストフレームワークは導入されていない。動作確認は実環境またはユーザーの報告に依存する。
