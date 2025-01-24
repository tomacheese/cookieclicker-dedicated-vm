$steam_username = "book000"

function IsRunningCookieClicker {
    $process = Get-Process -Name "Cookie Clicker" -ErrorAction SilentlyContinue
    return $null -ne $process
}

Set-Location -Path (Get-Location).Path
$timeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Tokyo Standard Time")
$currentDateTime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date).ToUniversalTime(), $timeZone)

$xml = Invoke-WebRequest -Uri "https://steamcommunity.com/id/${steam_username}?xml=1&$(Get-Date -Format yyyyMMddHHmmss)" -UseBasicParsing
($xml.Content -match "<onlineState>(.+?)</onlineState>") | Out-Null
$onlineState = $Matches[1]
($xml.Content -match "<gameName><!\[CDATA\[(.+?)\]\]></gameName>") | Out-Null
$gameName = $Matches[1]

if ($onlineState -eq "in-game") {
    Write-Output "$currentDateTime In game ($gameName)"
    if (Test-Path "nextStartGame") {
        Remove-Item "nextStartGame"
    }
    if (($gameName -ne "Cookie Clicker") -and (IsRunningCookieClicker)) {
        # Close Steam
        Write-Output "$currentDateTime Close Steam"
        Stop-Process -Name "Cookie Clicker" -ErrorAction SilentlyContinue
        Stop-Process -Name "steam" -ErrorAction SilentlyContinue
        Stop-Process -Name "steamwebhelper" -ErrorAction SilentlyContinue

        # 1分経っても終了しない場合は強制終了
        $count = 0
        while ($true) {
            if (!(IsRunningCookieClicker)) {
                break
            }
            Write-Output "Cookie Clicker is running... (Closing $count)"
            Start-Sleep -Seconds 1
            $count++
            if ($count -ge 60) {
                Write-Output "$currentDateTime force close"
                Stop-Process -Name "Cookie Clicker" -Force -ErrorAction SilentlyContinue
                Stop-Process -Name "steam" -Force -ErrorAction SilentlyContinue
                Stop-Process -Name "steamwebhelper" -Force -ErrorAction SilentlyContinue
                break
            }
        }
    }
    exit
}

if (IsRunningCookieClicker) {
    Write-Output "$currentDateTime Cookie Clicker is running"
    if (Test-Path "nextStartGame") {
        Remove-Item "nextStartGame"
    }
    exit
}

Write-Output "$currentDateTime Not in game"

if (!(Test-Path "nextStartGame")) {
    New-Item -ItemType File -Path "nextStartGame" | Out-Null
    Write-Output "$currentDateTime Next to Start Game"
    exit
}

Write-Output "$currentDateTime Game start..."
Start-Process -FilePath "steam://rungameid/1454400"
Start-Sleep -Seconds 1

$count = 0
while ($true) {
    if (IsRunningCookieClicker) {
        break
    }
    Write-Output "Cookie Clicker is not running... (Starting $count)"
    Start-Sleep -Seconds 1
    $count++
    if ($count -ge 300) {
        Write-Output "$currentDateTime start failed"
        Stop-Process -Name "steamwebhelper"
        Stop-Process -Name "steam"
        exit
    }
}

Start-Sleep -Seconds 3

# Optional: Uncomment if you have a script for minimizing the Cookie Clicker window
# Start-Process -FilePath ".\minimalize-CookieClicker.vbs"

Write-Output "$currentDateTime started"
Remove-Item "nextStartGame"
