# Read-only Windows preflight. Run in ordinary PowerShell; no Administrator needed.
# Prints selected hardware/software facts only. No uploads or configuration changes.
# Do not commit your output to the public repository.
$ErrorActionPreference = 'Stop'
try {
    $osInfo = Get-CimInstance Win32_OperatingSystem
    $systemInfo = Get-CimInstance Win32_ComputerSystem
    $cpuInfo = @(Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors)
    $diskInfo = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        [ordered]@{
            Drive = $_.DeviceID
            SizeGB = [math]::Round($_.Size / 1GB, 1)
            FreeGB = [math]::Round($_.FreeSpace / 1GB, 1)
        }
    })
    $commandInfo = [ordered]@{}
    foreach ($toolName in @('git', 'py', 'python', 'uv', 'node', 'npm', 'codex', 'winget', 'wsl')) {
        $commandInfo[$toolName] = [bool](Get-Command $toolName -ErrorAction SilentlyContinue)
    }
    [ordered]@{
        OS = $osInfo.Caption
        OSVersion = $osInfo.Version
        Architecture = $osInfo.OSArchitecture
        RAM_GB = [math]::Round($systemInfo.TotalPhysicalMemory / 1GB, 1)
        CPU = $cpuInfo
        Disks = $diskInfo
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
        CommandsOnPath = $commandInfo
        Note = 'Command presence is not a working-version check; Windows Python aliases can appear without Python installed.'
    } | ConvertTo-Json -Depth 5
} catch {
    Write-Output 'Preflight could not read a required Windows system property. Share the error category, not a full system export.'
    Write-Output $_.CategoryInfo.Category
    exit 1
}
