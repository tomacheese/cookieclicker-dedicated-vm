# AGENTS.md

## 言語ルール

- コミットメッセージの説明、PR / Issue のタイトルと本文、コードコメント、ドキュメントは日本語で書く。
- 日本語と英数字の間には半角スペースを入れる。
- ログ / エラーメッセージ: 新規に追加するものは英語で書く。既存の日本語の `Write-Host` の実行時文字列は変更しない。既存メッセージが絵文字で始まる場合はそのスタイルに合わせる。
- 例外: 実行時文字列(既存のまま維持)、引用、技術的な識別子。

## 概要

Steam 版 Cookie Clicker を専用の Windows VM で動かし続けるための PowerShell / Batch スクリプト群。オーナーの Steam プロファイルを定期的に確認し、他のゲームをプレイ中は Cookie Clicker と Steam を終了し、プレイ終了後に再起動する。Chrome リモートデスクトップ接続時のウィンドウ最小化も行う。

## 開発コマンド

ビルドシステム、パッケージマネージャー、テストフレームワークはない。PowerShell 7 (`pwsh`) でスクリプトを直接実行する。

- `checkInGame.bat`: エントリポイント。`git pull`、`pwsh -File checkInGame.ps1`、`timeout /T 180 /NOBREAK` を無限ループで繰り返す。
- `pwsh -File checkInGame.ps1`: 監視と状態遷移を 1 回だけ手動実行する。
- `pwsh -File chromerdp-clicker-minimalize.ps1`: Cookie Clicker のウィンドウを最小化する (5 秒間隔で常駐)。
- `pwsh -File minimalize-steam.ps1`: Steam (`Steam Client WebHelper`) のウィンドウを最小化する。

自動テストはない。動作確認には Steam と Cookie Clicker が入った Windows 環境が必要で、実行してプロセスやウィンドウの状態を観察する。

## アーキテクチャ

- `checkInGame.ps1`: 中核ロジック。`https://steamcommunity.com/id/<user>?xml=1` を取得し、`<onlineState>` と `<gameName>` を正規表現で抽出して、Cookie Clicker (`steam://rungameid/1454400`) を起動するか終了するかを決める。`nextStartGame` マーカーファイルで再起動を 1 サイクル遅らせる。
- `chromerdp-clicker-minimalize.ps1` / `minimalize-steam.ps1`: `user32.dll` を `Add-Type` の P/Invoke で呼び出すウィンドウ操作。Windows 専用。
- `checkInGame.bat`: PowerShell スクリプトをループ実行するラッパー。

## 規約

- 既存のインデントと命名に合わせ、無関係な箇所を整形しない。
- 関数や複雑なロジックには、意図 (なぜそうするか) を説明するコメントを付ける。
- コミットは Conventional Commits、ブランチは Conventional Branch の短縮形 (`feat`、`fix` など)。

## リポジトリ固有の注意点

- `checkInGame.ps1` 冒頭の `$steam_username` は Steam のログイン名ではなく、Steam Community のカスタム URL の ID (`steamcommunity.com/id/<id>` の `<id>`)。オーナー固有の公開 ID であり、秘密情報ではない。
- `checkInGame.bat` はループのたびに `git pull` で自己更新するため、コミットしたスクリプトの変更は VM に手動で配布しなくても反映される。
- `checkInGame.bat` は自身で無限ループするので、タスクスケジューラの定期実行トリガーでは多重起動になる。「ログオン時に 1 回」のトリガーかスタートアップのショートカットで 1 度だけ起動する。
- `Stop-Process` / `Start-Process` は、通常終了 → 一定時間後に強制終了というパターンと、リトライ上限 (終了待ち 60 回、起動待ち 300 回) を維持する。Cookie Clicker や Steam が固まったまま、または上限なしで待ち続ける状態にしてはならない。
- `$Matches` は `-match` が成功したときのみ有効。Steam の XML にフィールドが無い場合を考慮する。
- `nextStartGame` の作成と削除の整合性を崩さない (ゲームプレイ中、Cookie Clicker 起動中、起動完了時に削除し、未起動で初回検出時に作成する)。
- 認証情報、API キー、既存の `$steam_username` (公開 ID) 以外の個人 ID をコミットしない。ログにも出力しない。

## ドキュメント更新

スクリプトの追加・削除・改名、実行コマンドの変更、タスクスケジューラや VM の前提の変更があれば、このファイルと `README.md` を更新する。
