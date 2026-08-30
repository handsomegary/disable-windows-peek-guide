[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$RestartExplorer
)

$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$valueName = "ExtendedUIHoverTime"

$item = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $item) {
    Write-Host "$valueName is not set. Nothing to restore."
}
elseif ($PSCmdlet.ShouldProcess($registryPath, "Remove $valueName")) {
    Remove-ItemProperty -Path $registryPath -Name $valueName
    Write-Host "Removed $valueName."
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

