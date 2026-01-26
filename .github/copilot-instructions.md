# GitHub Copilot Instructions

## プロジェクト概要
- 目的: Steam 版 Cookie Clicker を専用 VM で自動実行・管理する
- 主な機能: 自動起動/終了、ウィンドウ最小化、Steam 連携
- 対象ユーザー: 自分 (Cookie Clicker プレイヤー)

## 共通ルール
- 会話は日本語で行う。
- PR とコミットは Conventional Commits に従う。
- 日本語と英数字の間には半角スペースを入れる。

## 技術スタック
- 言語: PowerShell, Batch
- プラットフォーム: Windows

## 開発コマンド
```powershell
# メイン監視スクリプト実行
.
checkInGame.bat

# ウィンドウ最小化スクリプト
.
chromerdp-clicker-minimalize.ps1
```

## セキュリティ / 機密情報
- `$steam_username` などの設定値以外に、機密情報をコードに含めないこと。
