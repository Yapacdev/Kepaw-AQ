# ============================================
#  KepawAQ.ps1 - Prevent Sleep & Screen Off
# ============================================
# Keeps system and display awake using
# Windows API (no mouse movement) v2.0
#
# Author: Yapacdev
# ============================================

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class PowerUtil {
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern uint SetThreadExecutionState(uint esFlags);

    public const uint ES_CONTINUOUS        = 0x80000000;
    public const uint ES_SYSTEM_REQUIRED   = 0x00000001;
    public const uint ES_DISPLAY_REQUIRED  = 0x00000002;
}
"@

# Flags to keep system + display awake
$flags = [PowerUtil]::ES_CONTINUOUS `
       -bor [PowerUtil]::ES_SYSTEM_REQUIRED `
       -bor [PowerUtil]::ES_DISPLAY_REQUIRED

Write-Host ""
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host "   Kepaw AQ is RUNNING" -ForegroundColor Green
Write-Host "   Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host ""

$interval = 360
try {
    while ($true) {
        [PowerUtil]::SetThreadExecutionState($flags) | Out-Null
        $timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "  [$timestamp] Keeping light settings... (next check in $interval sec)" -ForegroundColor DarkGray

        Start-Sleep -Seconds $interval
    }
}
finally {
    # Restore default behavior
    [PowerUtil]::SetThreadExecutionState([PowerUtil]::ES_CONTINUOUS) | Out-Null
    Write-Host ""
    Write-Host "  Kepaw AQ stopped. Normal power settings restored." -ForegroundColor Yellow
    Write-Host ""
}
