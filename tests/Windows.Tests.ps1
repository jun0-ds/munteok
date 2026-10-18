# Run with Windows PowerShell 5.1 or PowerShell 7; no test packages required.
$ErrorActionPreference = 'Stop'
$SourceRoot = Split-Path $PSScriptRoot -Parent
$TestRoot = Join-Path ([IO.Path]::GetTempPath()) ('munteok-tests-' + [guid]::NewGuid().ToString('N'))
function Assert-True($Value, [string]$Message) {
    if (-not $Value) { throw $Message }
}
function Write-TestText([string]$Path, [string]$Value) {
    [IO.File]::WriteAllText($Path, $Value, (New-Object Text.UTF8Encoding($true)))
}
try {
    $Workspace = Join-Path $TestRoot '한글 작업 공간'
    & (Join-Path $SourceRoot 'setup.ps1') -WorkspaceRoot $Workspace
    Assert-True (Test-Path (Join-Path $Workspace 'AGENTS.md')) 'Root instruction was not created.'
    Assert-True (Test-Path (Join-Path $Workspace '개인/보관')) 'Personal archive was not created.'
    foreach ($Directory in @('업무/보관', '.munteok/hearth', '.munteok/desk/memory/core', '.munteok/desk/memory/domain',
        '.munteok/desk/memory/archive', '.munteok/desk/memory/routes', '.munteok/desk/notes', '.munteok/desk/agenda', '.munteok/state', '.munteok/tools')) {
        Assert-True (Test-Path (Join-Path $Workspace $Directory)) "Missing directory: $Directory"
    }
    $Install = Get-Content (Join-Path $Workspace '.munteok/state/install.json') -Encoding UTF8 -Raw | ConvertFrom-Json
    Assert-True ($Install.frameworkVersion -eq '0.2.0') 'Installed version does not match the source.'
    Assert-True ((Get-Content (Join-Path $Workspace 'CLAUDE.md') -Raw -Encoding UTF8).Trim() -eq '@AGENTS.md') 'Claude adapter missing.'
    Assert-True (-not (Test-Path (Join-Path $Workspace 'bedrock/bobusang'))) 'Sync component should not be installed.'
    Write-Host 'PASS: empty workspace with Korean and space path, directories, version and adapter'

    $AgentsPath = Join-Path $Workspace 'AGENTS.md'
    $CorePath = Join-Path $Workspace '.munteok/desk/memory/core/identity.md'
    $ContextPath = Join-Path $Workspace 'CONTEXT.md'
    Write-TestText $CorePath 'USER CORE: preserve me'
    Write-TestText $ContextPath 'USER ROUTER: preserve me'
    Write-TestText $AgentsPath ("BEFORE`r`n" + (Get-Content $AgentsPath -Raw -Encoding UTF8) + "AFTER`r`n")
    $AgentsBefore = Get-Content $AgentsPath -Raw -Encoding UTF8
    $CoreBefore = [Convert]::ToBase64String([IO.File]::ReadAllBytes($CorePath))
    $InstalledAt = $Install.installedAt
    & (Join-Path $SourceRoot 'setup.ps1') -WorkspaceRoot $Workspace
    Assert-True ((Get-Content $AgentsPath -Raw -Encoding UTF8) -eq $AgentsBefore) 'Managed block duplicated or outside content changed.'
    Assert-True ([Convert]::ToBase64String([IO.File]::ReadAllBytes($CorePath)) -eq $CoreBefore) 'User core changed on reinstall.'
    Assert-True ((Get-Content $ContextPath -Raw -Encoding UTF8) -eq 'USER ROUTER: preserve me') 'User router changed on reinstall.'
    $Install = Get-Content (Join-Path $Workspace '.munteok/state/install.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    Assert-True ($Install.installedAt -eq $InstalledAt) 'Initial install timestamp changed.'
    Write-Host 'PASS: reinstall preserves user data and AGENTS content outside the managed block'

    $ExistingRoot = Join-Path $TestRoot 'existing'
    New-Item -ItemType Directory -Path $ExistingRoot -Force | Out-Null
    $ExistingClaude = Join-Path $ExistingRoot 'CLAUDE.md'
    Write-TestText $ExistingClaude 'Existing standalone Claude contract'
    Write-TestText (Join-Path $ExistingRoot 'AGENTS.md') 'Existing root contract'
    $ExistingBytes = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ExistingClaude))
    & (Join-Path $SourceRoot 'setup.ps1') -WorkspaceRoot $ExistingRoot
    Assert-True ([Convert]::ToBase64String([IO.File]::ReadAllBytes($ExistingClaude)) -eq $ExistingBytes) 'Standalone CLAUDE.md was overwritten.'
    Assert-True ((Get-Content (Join-Path $ExistingRoot 'AGENTS.md') -Raw -Encoding UTF8).StartsWith('Existing root contract')) 'Existing AGENTS.md was lost.'
    Write-Host 'PASS: standalone CLAUDE.md and existing AGENTS.md are preserved'

    $Rejected = $false
    try { & (Join-Path $SourceRoot 'setup.ps1') -WorkspaceRoot (Join-Path $SourceRoot 'private-data-test') } catch { $Rejected = $true }
    Assert-True $Rejected 'Workspace inside public source was accepted.'
    $Rejected = $false
    try { & (Join-Path $SourceRoot 'setup.ps1') -WorkspaceRoot 'relative-workspace' } catch { $Rejected = $true }
    Assert-True $Rejected 'Relative workspace was accepted.'
    foreach ($BadPath in @('C:relative-workspace', '\relative-workspace', 'C:\')) {
        $Rejected = $false
        try { & (Join-Path $SourceRoot 'setup.ps1') -WorkspaceRoot $BadPath } catch { $Rejected = $true }
        Assert-True $Rejected "Drive-relative or drive-root workspace was accepted: $BadPath"
    }
    $BrokenRoot = Join-Path $TestRoot 'broken-markers'
    New-Item -ItemType Directory -Path $BrokenRoot | Out-Null
    Write-TestText (Join-Path $BrokenRoot 'AGENTS.md') '<!-- munteok:workspace:start --> private rules'
    $Rejected = $false
    try { & (Join-Path $SourceRoot 'setup.ps1') -WorkspaceRoot $BrokenRoot } catch { $Rejected = $true }
    Assert-True $Rejected 'Malformed markers were silently replaced.'
    Assert-True ((Get-Content (Join-Path $BrokenRoot 'AGENTS.md') -Raw -Encoding UTF8) -eq '<!-- munteok:workspace:start --> private rules') 'Malformed AGENTS content was damaged.'
    Write-Host 'PASS: unsafe source/relative roots and malformed markers are rejected'

    . (Join-Path $Workspace '.munteok/tools/Check-Updates.ps1') -WorkspaceRoot $Workspace
    $script:Calls = 0
    $script:ReleaseTag = 'v0.10.0'
    function Get-MunteokLatestRelease {
        $script:Calls++
        [pscustomobject]@{ tag_name = $script:ReleaseTag; draft = $false; prerelease = $false }
    }
    $CheckState = Join-Path $Workspace '.munteok/state/update-check.json'
    Invoke-MunteokUpdateCheck $Workspace
    $State = Get-Content $CheckState -Raw -Encoding UTF8 | ConvertFrom-Json
    Assert-True ($script:Calls -eq 1 -and $State.status -eq 'update-available') 'Numeric version comparison failed (0.10.0 > 0.2.0).'
    Invoke-MunteokUpdateCheck $Workspace
    Assert-True ($script:Calls -eq 1) 'Daily check made a duplicate network call.'
    $State.checkedOn = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
    Write-TestText $CheckState ($State | ConvertTo-Json)
    $script:ReleaseTag = 'v0.1.9'
    Invoke-MunteokUpdateCheck $Workspace
    $State = Get-Content $CheckState -Raw -Encoding UTF8 | ConvertFrom-Json
    Assert-True ($script:Calls -eq 2 -and $State.status -eq 'current') 'Lower release should not prompt a downgrade.'
    Write-Host 'PASS: numeric version comparison, next-day retry and daily request deduplication'

    $State.checkedOn = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
    Write-TestText $CheckState ($State | ConvertTo-Json)
    function Get-MunteokLatestRelease { $script:Calls++; throw 'Simulated offline environment' }
    Invoke-MunteokUpdateCheck $Workspace
    Invoke-MunteokUpdateCheck $Workspace
    $State = Get-Content $CheckState -Raw -Encoding UTF8 | ConvertFrom-Json
    Assert-True ($script:Calls -eq 3 -and $State.status -eq 'unavailable') 'Offline checks blocked work or retried on the same day.'
    Write-Host 'PASS: offline failure is nonblocking and is attempted only once that day'

    $State.checkedOn = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
    Write-TestText $CheckState ($State | ConvertTo-Json)
    function Get-MunteokLatestRelease { [pscustomobject]@{ tag_name = 'v99.0.0-beta.1'; draft = $false; prerelease = $true } }
    Invoke-MunteokUpdateCheck $Workspace
    $State = Get-Content $CheckState -Raw -Encoding UTF8 | ConvertFrom-Json
    Assert-True ($State.status -eq 'unavailable') 'Prerelease was treated as a stable update.'
    Assert-True ([Convert]::ToBase64String([IO.File]::ReadAllBytes($CorePath)) -eq $CoreBefore) 'Updater modified user data.'
    Write-Host 'PASS: prerelease rejection and user content preserved by update check'
    $MissingStateRoot = Join-Path $TestRoot 'not-installed'
    Invoke-MunteokUpdateCheck $MissingStateRoot
    Write-Host 'PASS: missing installation state is nonblocking'
    Write-Host 'All Windows workspace tests passed.'
}
finally {
    if (Test-Path $TestRoot) { Remove-Item -LiteralPath $TestRoot -Recurse -Force }
}
