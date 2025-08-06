# Wooden Ghost Repository Cleanup Script
# Remove unnecessary repositories and large files

param([string]$action = "analyze")

function WriteMessage {
    param($text, $color = "green")
    Write-Host "cleanup: $text" -ForegroundColor $color
}

function AnalyzeRepositories {
    WriteMessage "analyzing repository sizes and usage" "cyan"
    
    $reposPath = "repositories"
    if (-not (Test-Path $reposPath)) {
        WriteMessage "no repositories directory found" "yellow"
        return
    }
    
    $repos = Get-ChildItem $reposPath -Directory
    $totalSize = 0
    $analysis = @()
    
    foreach ($repo in $repos) {
        $size = (Get-ChildItem $repo.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($size / 1MB, 2)
        $totalSize += $size
        
        $lastModified = (Get-ChildItem $repo.FullName -Recurse -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
        
        $analysis += @{
            Name = $repo.Name
            SizeMB = $sizeMB
            LastModified = $lastModified
        }
    }
    
    $totalSizeMB = [math]::Round($totalSize / 1MB, 2)
    WriteMessage "total repository size: $totalSizeMB MB" "magenta"
    
    WriteMessage "repository analysis:" "yellow"
    $analysis | Sort-Object SizeMB -Descending | ForEach-Object {
        $agedays = (Get-Date).Subtract($_.LastModified).Days
        WriteMessage "  folder $($_.Name): $($_.SizeMB) MB (last modified $agedays days ago)" "white"
    }
    
    # Identify repositories to keep for temporal optimization
    $essential = @("powershell", "linuxcommandlibrary")
    $nonessential = $analysis | Where-Object { $_.Name -notin $essential }
    
    if ($nonessential.Count -gt 0) {
        WriteMessage "non essential repositories found:" "red"
        $nonessential | ForEach-Object {
            WriteMessage "  repository $($_.Name): $($_.SizeMB) MB" "red"
        }
        
        $savedSpace = ($nonessential | Measure-Object -Property SizeMB -Sum).Sum
        WriteMessage "potential space savings: $savedSpace MB" "green"
    }
    
    return $analysis
}

function CleanupRepositories {
    param($analysis)
    
    WriteMessage "starting cleanup process" "cyan"
    
    $essential = @("powershell", "linuxcommandlibrary")
    $nonessential = $analysis | Where-Object { $_.Name -notin $essential }
    
    if ($nonessential.Count -eq 0) {
        WriteMessage "no non essential repositories found" "green"
        return
    }
    
    foreach ($repo in $nonessential) {
        $repoPath = "repositories/$($repo.Name)"
        if (Test-Path $repoPath) {
            WriteMessage "removing repository: $($repo.Name)" "yellow"
            Remove-Item $repoPath -Recurse -Force
            WriteMessage "removed: $($repo.Name) (saved $($repo.SizeMB) MB)" "green"
        }
    }
}

function CleanupLargeFiles {
    WriteMessage "scanning for large files to remove" "cyan"
    
    $extensions = @("*.wav", "*.mp3", "*.mp4", "*.mov", "*.avi", "*.mkv", "*.zip", "*.rar", "*.7z")
    $largeFiles = @()
    
    foreach ($ext in $extensions) {
        $files = Get-ChildItem -Path . -Filter $ext -Recurse -File
        foreach ($file in $files) {
            if ($file.Length -gt 10MB) {
                $sizeMB = [math]::Round($file.Length / 1MB, 2)
                $largeFiles += @{
                    Path = $file.FullName
                    SizeMB = $sizeMB
                    Extension = $file.Extension
                }
            }
        }
    }
    
    if ($largeFiles.Count -gt 0) {
        WriteMessage "large files found:" "red"
        $largeFiles | Sort-Object SizeMB -Descending | ForEach-Object {
            WriteMessage "  $($_.Path): $($_.SizeMB) MB" "red"
        }
        
        $totalSize = ($largeFiles | Measure-Object -Property SizeMB -Sum).Sum
        WriteMessage "total large files size: $totalSize MB" "magenta"
    } else {
        WriteMessage "no large files found" "green"
    }
    
    return $largeFiles
}

# Main execution
switch ($action) {
    "analyze" {
        $analysis = AnalyzeRepositories
        $largeFiles = CleanupLargeFiles
        
        WriteMessage "analysis complete" "green"
        WriteMessage "run with 'cleanup' parameter to remove non essential items" "yellow"
    }
    "cleanup" {
        $analysis = AnalyzeRepositories
        CleanupRepositories $analysis
        
        WriteMessage "cleanup complete!" "green"
        WriteMessage "run sync script to update remaining repositories" "cyan"
    }
    default {
        WriteMessage "usage: cleanup_repositories.ps1 [analyze|cleanup]" "yellow"
    }
}