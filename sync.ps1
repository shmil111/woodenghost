param([string]$action = "help")

$githubuser = "shmil111"
$repospath = "repositories"

function writemessage {
    param($text, $color = "green")
    Write-Host "✨ $text" -ForegroundColor $color
}

function ensuredir {
    param($path)
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        writemessage "created: $path"
    }
}

function syncrepos {
    writemessage "syncing essential repositories from github.com/$githubuser" "cyan"
    
    ensuredir $repospath
    Set-Location $repospath
    
    # Only sync essential repositories for temporal optimization
    $essentialrepos = @("powershell", "linuxcommandlibrary")
    
    foreach ($repo in $essentialrepos) {
        $repopath = $repo
        $repourl = "https://github.com/$githubuser/$repo.git"
        
        if (Test-Path $repopath) {
            writemessage "updating: $repo" "yellow"
            Set-Location $repopath
            
            # Check if repo is clean before pulling
            $status = git status --porcelain
            if ($status) {
                writemessage "repository has uncommitted changes, skipping pull" "red"
            } else {
                git pull --quiet
                writemessage "updated successfully" "green"
            }
            Set-Location ..
        } else {
            writemessage "cloning: $repo"
            git clone $repourl --quiet --depth 1
            if ($LASTEXITCODE -eq 0) {
                writemessage "cloned successfully" "green"
            } else {
                writemessage "clone failed for $repo" "red"
            }
        }
    }
    
    Set-Location ..
    writemessage "essential repositories sync completed!" "green"
}

function showstatus {
    writemessage "wooden ghost workspace status" "magenta"
    
    if (Test-Path $repospath) {
        $repos = Get-ChildItem $repospath -Directory
        writemessage "repositories: $($repos.count)"
        foreach ($repo in $repos) {
            writemessage "  folder $($repo.name)" "white"
        }
    } else {
        writemessage "no repositories found" "yellow"
    }
}

function showhelp {
    Write-Host ""
    Write-Host "wooden ghost sync" -ForegroundColor magenta
    Write-Host "simple repository sync for temporal optimization" -ForegroundColor cyan
    Write-Host ""
    Write-Host "usage:" -ForegroundColor yellow
    Write-Host "  .\sync.ps1 sync     - sync all repositories"
    Write-Host "  .\sync.ps1 status   - show status"
    Write-Host "  .\sync.ps1 help     - show this help"
    Write-Host ""
}

switch ($action.tolower()) {
    "sync" { 
        showstatus
        syncrepos 
        showstatus
    }
    "status" { showstatus }
    "help" { showhelp }
    default { showhelp }
} 