#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$WorkspaceRoot
)
$ErrorActionPreference = 'Stop'
$SourceRoot = $PSScriptRoot
$TemplateRoot = Join-Path $SourceRoot 'templates/workspace'
$Version = (Get-Content -LiteralPath (Join-Path $SourceRoot 'VERSION') -Raw).Trim()

# Never place private runtime data in the public framework checkout.
if (-not [IO.Path]::IsPathRooted($WorkspaceRoot) -or
    ($env:OS -eq 'Windows_NT' -and $WorkspaceRoot -notmatch '^(?:[a-zA-Z]:[\\/]|\\\\[^\\/]+[\\/][^\\/]+(?:[\\/]|$))')) {
    throw 'WorkspaceRoot must be an absolute path, including its drive or UNC share.'
}
$WorkspaceRoot = [IO.Path]::GetFullPath($WorkspaceRoot).TrimEnd([char[]]'\/')
$SourcePath = [IO.Path]::GetFullPath($SourceRoot).TrimEnd([char[]]'\/')
if ($WorkspaceRoot.Equals($SourcePath, [StringComparison]::OrdinalIgnoreCase) -or
    $WorkspaceRoot.StartsWith($SourcePath + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Choose a workspace outside the public munteok source checkout.'
}
if ($WorkspaceRoot -eq [IO.Path]::GetPathRoot($WorkspaceRoot).TrimEnd([char[]]'\/')) {
    throw 'Choose a dedicated workspace folder, not a drive root.'
}
function Write-Utf8([string]$Path, [string]$Content) {
    [IO.File]::WriteAllText($Path, $Content, (New-Object Text.UTF8Encoding($true)))
}

$Directories = @(
    '.munteok/hearth', '.munteok/desk/memory/core', '.munteok/desk/memory/domain',
    '.munteok/desk/memory/archive', '.munteok/desk/memory/routes', '.munteok/desk/notes',
    '.munteok/desk/agenda', '.munteok/state', '.munteok/tools', '업무/보관', '개인/보관'
)
foreach ($Directory in $Directories) {
    New-Item -ItemType Directory -Path (Join-Path $WorkspaceRoot $Directory) -Force | Out-Null
}
# User-editable content is seeded once. Updates never replace it.
Get-ChildItem -LiteralPath $TemplateRoot -Recurse -File -Force | ForEach-Object {
    $Relative = $_.FullName.Substring($TemplateRoot.Length).TrimStart([char[]]'\/')
    if ($Relative -eq 'AGENTS-section.md') { return }
    $Destination = Join-Path $WorkspaceRoot $Relative
    if (-not (Test-Path -LiteralPath $Destination)) {
        New-Item -ItemType Directory -Path (Split-Path $Destination -Parent) -Force | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination $Destination
    }
}

$AgentsPath = Join-Path $WorkspaceRoot 'AGENTS.md'
$Start = '<!-- munteok:workspace:start -->'
$End = '<!-- munteok:workspace:end -->'
$Section = (Get-Content -LiteralPath (Join-Path $TemplateRoot 'AGENTS-section.md') -Encoding UTF8 -Raw).TrimEnd()
$Block = $Start + "`r`n" + $Section + "`r`n" + $End
$Original = ''
if (Test-Path -LiteralPath $AgentsPath) { $Original = Get-Content -LiteralPath $AgentsPath -Encoding UTF8 -Raw }
if ($null -eq $Original) { $Original = '' }
$HasStart = $Original.Contains($Start)
$HasEnd = $Original.Contains($End)
if ($HasStart -or $HasEnd) {
    $Pattern = '(?s)' + [regex]::Escape($Start) + '.*?' + [regex]::Escape($End)
    $MatchesFound = [regex]::Matches($Original, $Pattern)
    if ($MatchesFound.Count -ne 1 -or ([regex]::Matches($Original, [regex]::Escape($Start))).Count -ne 1 -or
        ([regex]::Matches($Original, [regex]::Escape($End))).Count -ne 1) {
        throw 'AGENTS.md contains incomplete or duplicate munteok markers. Preserve it and repair the markers before retrying.'
    }
    $Match = $MatchesFound[0]
    $Updated = $Original.Substring(0, $Match.Index) + $Block + $Original.Substring($Match.Index + $Match.Length)
} else {
    $Updated = $Original + "`r`n" + $Block + "`r`n"
}
Write-Utf8 $AgentsPath $Updated

$ClaudePath = Join-Path $WorkspaceRoot 'CLAUDE.md'
if (-not (Test-Path -LiteralPath $ClaudePath)) {
    Write-Utf8 $ClaudePath "@AGENTS.md`r`n"
} else {
    $ClaudeContent = (Get-Content -LiteralPath $ClaudePath -Encoding UTF8 -Raw)
    if ($null -eq $ClaudeContent -or $ClaudeContent.Trim() -ne '@AGENTS.md') {
        Write-Warning 'Existing CLAUDE.md was preserved. Review its rules and add @AGENTS.md only after resolving any conflicts.'
    }
}
# Only framework-owned runtime tools are replaced on reinstall.
Copy-Item -LiteralPath (Join-Path $SourceRoot 'scripts/Check-Updates.ps1') -Destination (Join-Path $WorkspaceRoot '.munteok/tools/Check-Updates.ps1') -Force
$InstallPath = Join-Path $WorkspaceRoot '.munteok/state/install.json'
$InstalledAt = (Get-Date).ToString('o')
if (Test-Path -LiteralPath $InstallPath) {
    $OldInstall = Get-Content -LiteralPath $InstallPath -Encoding UTF8 -Raw | ConvertFrom-Json
    if ($OldInstall.installedAt) { $InstalledAt = $OldInstall.installedAt }
}
$InstallState = [ordered]@{ frameworkVersion = $Version; installedAt = $InstalledAt; updatedAt = (Get-Date).ToString('o'); sourceRoot = $SourceRoot }
Write-Utf8 $InstallPath ($InstallState | ConvertTo-Json)
Write-Host "Munteok $Version ready: $WorkspaceRoot"
Write-Host 'Start your agent in this workspace and ask it to read AGENTS.md and CONTEXT.md.'
Write-Host 'Core memory, notes, scope routing and archive folders are local. No sync or UI component was installed.'
