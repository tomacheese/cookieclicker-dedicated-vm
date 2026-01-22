# Cookie Clicker Dedicated VM

Cookie Clicker を専用 VM で自動実行・管理するための PowerShell スクリプト群です。

## 概要

Steam 版 Cookie Clicker を専用の仮想マシンで常時稼働させるためのツールです。他のゲームをプレイしている間は Cookie Clicker を自動的に終了し、プレイ終了後に再起動します。

## 機能

- **自動起動/終了**: Steam プロファイルを監視し、他のゲームプレイ中は Cookie Clicker を終了
- **ウィンドウ最小化**: Chrome リモートデスクトップ接続時に自動でウィンドウを最小化
- **Steam 連携**: Steam のオンライン状態を XML API で取得して判断

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `checkInGame.ps1` | Steam のゲーム状態を監視し、Cookie Clicker の起動/終了を制御 |
| `checkInGame.bat` | `checkInGame.ps1` のバッチファイルラッパー |
| `chromerdp-clicker-minimalize.ps1` | Chrome RDP 接続時にウィンドウを最小化 |
| `minimalize-steam.ps1` | Steam ウィンドウの最小化 |

## 必要要件

- Windows
- PowerShell
- Steam（Cookie Clicker インストール済み）
- Chrome リモートデスクトップ（オプション）

## 設定

`checkInGame.ps1` の先頭にある `$steam_username` を自分の Steam ユーザー名に変更してください。

```powershell
$steam_username = "your_steam_username"
```

## 使用方法

タスクスケジューラで `checkInGame.bat` を定期実行するよう設定してください。

```batch
# 例: 1分ごとに実行
checkInGame.bat
```
