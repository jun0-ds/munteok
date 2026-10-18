#requires -Version 5.1
[CmdletBinding()]
param([Parameter(Mandatory = $true)][string]$WorkspaceRoot)

function Get-MunteokLatestRelease {
    # No credentials, workspace contents or device identity are sent.
    Invoke-RestMethod -UseBasicParsing -Uri 'https://api.github.com/repos/jun0-ds/munteok/releases/latest' -Headers @{ 'User-Agent' = 'munteok-update-check' } -TimeoutSec 6 -ErrorAction Stop
}
function Invoke-MunteokUpdateCheck([string]$Root) {
    # An unavailable network or damaged state must never block normal work.
    try {
        $StateDirectory = Join-Path $Root '.munteok/state'
        $Install = Get-Content -LiteralPath (Join-Path $StateDirectory 'install.json') -Encoding UTF8 -Raw -ErrorAction Stop | ConvertFrom-Json
        $StatePath = Join-Path $StateDirectory 'update-check.json'
        $Today = (Get-Date).ToString('yyyy-MM-dd') # local device date, once per day
        if (Test-Path -LiteralPath $StatePath) {
            $Previous = Get-Content -LiteralPath $StatePath -Encoding UTF8 -Raw -ErrorAction Stop | ConvertFrom-Json
            if ($Previous.checkedOn -eq $Today) { return }
        }
        $State = [ordered]@{ checkedOn = $Today; status = 'unavailable'; installedVersion = $Install.frameworkVersion }
        # Record the attempt before network I/O so even an interrupted call is not repeated today.
        $Utf8 = New-Object Text.UTF8Encoding($true)
        [IO.File]::WriteAllText($StatePath, ($State | ConvertTo-Json), $Utf8)
        try {
            $Release = Get-MunteokLatestRelease
            $LatestText = [string]$Release.tag_name
            if ($Release.draft -or $Release.prerelease -or $LatestText -notmatch '^v?\d+\.\d+\.\d+$') { throw 'No stable version was returned.' }
            $InstalledText = [string]$Install.frameworkVersion
            if ($InstalledText -notmatch '^\d+\.\d+\.\d+$') { throw 'Installed version is not a stable version.' }
            $Latest = [version]($LatestText -replace '^v', '')
            $Installed = [version]$InstalledText
            $State['latestVersion'] = $Latest.ToString()
            if ($Latest -gt $Installed) {
                $State.status = 'update-available'
                Write-Host "Munteok update available: $InstalledText -> $Latest. Review https://github.com/jun0-ds/munteok/releases before applying it."
            } else { $State.status = 'current' }
        } catch {
            Write-Host 'Munteok update check unavailable today; continue your work. It will retry on the next local day.'
        }
        [IO.File]::WriteAllText($StatePath, ($State | ConvertTo-Json), $Utf8)
    } catch {
        Write-Host 'Munteok update check skipped because local state could not be read or written; continue your work.'
    }
}
if ($MyInvocation.InvocationName -ne '.') { Invoke-MunteokUpdateCheck $WorkspaceRoot }
