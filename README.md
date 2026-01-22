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
| --- | --- |
| `checkInGame.ps1` | Steam のゲーム状態を監視し、Cookie Clicker の起動/終了を制御 |
| `checkInGame.bat` | `checkInGame.ps1` のバッチファイルラッパー |
| `chromerdp-clicker-minimalize.ps1` | Chrome RDP 接続時にウィンドウを最小化 |
| `minimalize-steam.ps1` | Steam ウィンドウの最小化 |

## 必要要件

- Windows
- PowerShell 7 以降（`pwsh` が使用可能であること）
- Git
- Steam（Cookie Clicker インストール済み）
- Chrome リモートデスクトップ（オプション）

## 設定

`checkInGame.ps1` の先頭にある `$steam_username` を自分の Steam Community カスタム URL（vanity URL）の ID 部分に変更してください。

これは `https://steamcommunity.com/id/<ここの部分>` に対応します（Steam のログイン名ではありません）。

```powershell
$steam_username = "your_vanity_url_id"
```

## 使用方法

`checkInGame.bat` 自体が無限ループで動作し、内部で `timeout 180` により定期チェックを行います。そのため、タスクスケジューラで「○分ごとに定期実行」のように設定すると、多重起動してしまいます。

タスクスケジューラを使う場合は、**「ログオン時に 1 回のみ実行」や「起動時に 1 回のみ実行」など、1 度だけ起動されるトリガー**に設定してください（もしくはスタートアップにショートカットを置くなどして、ログオン時に 1 回だけ起動させてください）。

```batch
REM 例: ログオン時に 1 回実行されるタスクなどから呼び出す
checkInGame.bat
```
