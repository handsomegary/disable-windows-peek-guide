[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateRange(0, 600000)]
    [int]$DelayMilliseconds = 30000,

    [switch]$RestartExplorer
)

$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$valueName = "ExtendedUIHoverTime"

if ($PSCmdlet.ShouldProcess($registryPath, "Set $valueName to $DelayMilliseconds")) {
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty `
        -Path $registryPath `
        -Name $valueName `
        -PropertyType DWord `
        -Value $DelayMilliseconds `
        -Force | Out-Null

    Write-Host "Set $valueName to $DelayMilliseconds milliseconds."
}

if ($RestartExplorer) {
    if ($PSCmdlet.ShouldProcess("explorer.exe", "Restart File Explorer")) {
        Stop-Process -Name explorer -Force
        Write-Host "File Explorer restart requested."
    }
}
else {
    Write-Host "Restart File Explorer, sign out, or restart Windows for the change to apply."
}

