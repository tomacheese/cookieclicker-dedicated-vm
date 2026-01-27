# Claude Code Instructions

## 目的
Claude Code の作業方針とプロジェクト固有ルールを示す

## 判断記録のルール
1. 判断内容の要約
2. 検討した代替案
3. 採用しなかった案とその理由
4. 前提条件・仮定・不確実性
5. 他エージェントによるレビュー可否

## プロジェクト概要
- 目的: Steam 版 Cookie Clicker を専用 VM で自動実行・管理する
- 主な機能: 他のゲームプレイ中の自動終了、Chrome RDP 接続時の最小化

## 重要ルール
- 会話言語: 日本語
- コミット規約: Conventional Commits
- コメント言語: 日本語
- エラーメッセージ: 英語

## 環境のルール
- ブランチ命名: Conventional Branch (short type)
- Windows 環境前提 (PowerShell 7 以降)

## コード改修時のルール
- エラーメッセージの絵文字統一 (既存に従う)
- docstring 記載 (日本語)

## 開発コマンド
- `checkInGame.bat`: 監視開始
- `checkInGame.ps1`: 監視ロジック本体

## アーキテクチャと主要ファイル
- `checkInGame.ps1`: Steam API をポーリングして状態遷移を管理
- `chromerdp-clicker-minimalize.ps1`: Chrome リモートデスクトップ接続時に Cookie Clicker ウィンドウを最小化

## テスト
- 自動テストなし。実機動作確認が必要。

## 作業チェックリスト
- 新規改修時: プロジェクト理解、ブランチ作成
- コミット・プッシュ前: Conventional Commits 確認
- PR 作成前: 機密情報確認
- PR 作成後: PR 本文作成、CI 確認 (あれば)
