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

function Minimize-Windows {
	param (
		[Parameter(Mandatory=$true)]
		[string]$ProcessName
	)

	$isFound = $false

	$processes = Get-Process | Where-Object { $_.ProcessName -eq $ProcessName }
	foreach ($process in $processes) {
		try {
			$processId = [System.IntPtr]::new($process.Id)

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
				}, $processId)

			if ($windowFound) {
				Write-Host "Minimized the window of the process: $ProcessName (PID: $($process.Id))"
			} else {
				Write-Host "Not found the window of the process: $ProcessName (PID: $($process.Id))"
			}
		} catch {
			Write-Host "Failed to minimize the window of the process: $ProcessName (PID: $($process.Id))"
			Write-Host $_.Exception.Message
		}
		$isFound = $true
	}
	
	return $isFound
}	

while ($true) {
	$result = Minimize-Windows -ProcessName "Steam Client WebHelper"
	if ($result) {
		break
	}

	Start-Sleep -Seconds 5
}
