# Import user32.dll functions for window management
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class User32 {
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
}
"@

# 定数定義
$SW_MINIMIZE = 6

# フラグ: 最小化済みかどうか
$alreadyMinimized = $false

# 指定されたプロセスのウィンドウを最小化する関数
function Minimize-CookieClickerWindows {
    param (
        [string]$targetProcessName = "Cookie Clicker.exe"
    )

    $cookieProcesses = Get-Process | Where-Object { $_.ProcessName -eq "Cookie Clicker" -or $_.Name -eq $targetProcessName }

    if ($cookieProcesses) {
        foreach ($cookieProcess in $cookieProcesses) {
            try {
                $cookieProcessId = [System.IntPtr]::new($cookieProcess.Id)

                $windowFound = $false
                [User32]::EnumWindows({ param ($hWnd, $lParam)
                    $processId = 0
                    [User32]::GetWindowThreadProcessId($hWnd, [ref]$processId) | Out-Null
                    if ($processId -eq $lParam.ToInt32()) {
                        [User32]::ShowWindow($hWnd, $SW_MINIMIZE) | Out-Null
                        $script:windowFound = $true
                        return $false # ウィンドウを見つけたので列挙を終了
                    }
                    return $true
                }, $cookieProcessId)

                if ($windowFound) {
                    Write-Host "Cookie Clicker.exe (PID: $($cookieProcess.Id)) を最小化しました。"
                } else {
                    Write-Host "Cookie Clicker.exe (PID: $($cookieProcess.Id)) のウィンドウが見つかりませんでした。"
                }
            } catch {
                Write-Host "プロセス ID ($($cookieProcess.Id)) を処理中にエラーが発生しました: $_"
            }
        }
        # 最小化が完了したのでフラグを設定
        $global:alreadyMinimized = $true
    } else {
        Write-Host "Cookie Clicker.exe プロセスが見つかりませんでした。"
    }
}

# remoting_desktop.exe の存在を確認する関数
function Check-RemotingHost {
    $result = TASKLIST /FI "IMAGENAME eq remoting_desktop.exe" /FI "SESSIONNAME eq Console"

    # 実行結果にプロセス名が含まれているか確認
    if ($result -match "remoting_desktop.exe") {
        return $true
    } else {
        return $false
    }
}

# 5秒ごとに確認
while ($true) {
    $remotingProcess = Check-RemotingHost
    if ($remotingProcess) {
        Write-Host "条件に一致する remoting_host.exe のタスクが存在します。"
        if (-not $alreadyMinimized) {
            Minimize-CookieClickerWindows
        } else {
            Write-Host "Cookie Clicker.exe は既に最小化済みです。"
        }
    } else {
        Write-Host "条件に一致する remoting_host.exe のタスクが存在しません。"
        # remoting_host.exe がなくなったらフラグをリセット
        $alreadyMinimized = $false
    }
    Start-Sleep -Seconds 5
}
