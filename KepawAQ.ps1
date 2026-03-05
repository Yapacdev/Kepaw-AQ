# ============================================
#  KepawAQ.ps1 - Prevent Sleep & Screen Off
# ============================================
# Moves the mouse slightly every 60 seconds
# AND uses SetThreadExecutionState to block
# Windows from sleeping or turning off the screen.
# Run as: Right-click > Run with PowerShell
# Stop with: Ctrl+C in the window
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

Add-Type -AssemblyName System.Windows.Forms

# Tell Windows: keep system AND display awake continuously
$flags = [PowerUtil]::ES_CONTINUOUS -bor [PowerUtil]::ES_SYSTEM_REQUIRED -bor [PowerUtil]::ES_DISPLAY_REQUIRED
[PowerUtil]::SetThreadExecutionState($flags) | Out-Null

Write-Host ""
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host "   Kepaw AQ is RUNNING" -ForegroundColor Green
Write-Host "   Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host ""

$interval = 360  # seconds between mouse nudges

try {
    while ($true) {
        # Nudge mouse position slightly (1px right, then back)
        $pos = [System.Windows.Forms.Cursor]::Position
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(($pos.X + 1), $pos.Y)
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.Cursor]::Position = $pos

        $timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "  [$timestamp] Keeping light settings... (next check in $interval sec)" -ForegroundColor DarkGray

        Start-Sleep -Seconds $interval
    }
}
finally {
    # Restore normal power settings when script exits
    [PowerUtil]::SetThreadExecutionState([PowerUtil]::ES_CONTINUOUS) | Out-Null
    Write-Host ""
    Write-Host "  Kepaw AQ stopped. Normal power settings restored." -ForegroundColor Yellow
    Write-Host ""
}
