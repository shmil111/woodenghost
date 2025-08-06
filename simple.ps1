Write-Host "✨ wooden ghost sync tool" -ForegroundColor magenta
Write-Host "simple repository sync for temporal optimization" -ForegroundColor cyan

if (Test-Path "repositories") {
    $repos = Get-ChildItem "repositories" -Directory
    Write-Host "repositories found: $($repos.count)" -ForegroundColor green
    foreach ($repo in $repos) {
        Write-Host "  📁 $($repo.name)" -ForegroundColor white
    }
} else {
    Write-Host "no repositories directory found" -ForegroundColor yellow
} 