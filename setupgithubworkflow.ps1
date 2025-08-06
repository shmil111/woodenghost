#!/usr/bin/env powershell

# GitHub Workflow Setup and predebugging Script for Wooden.Ghost
# Author: Nevo Mizrahi (Wooden.Ghost)
# Purpose: Configure repositories directory as default and prevent common issues

param(
    [string]$Action = "setup",
    [string]$RepoName = "",
    [switch]$Debug = $false
)

# Define paths
$WoodenGhostRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepositoriesPath = Join-Path $WoodenGhostRoot "repositories"
$ConfigPath = Join-Path $WoodenGhostRoot ".github-config"

# Ensure repositories directory exists
if (-not (Test-Path $RepositoriesPath)) {
    New-Item -ItemType Directory -Path $RepositoriesPath -Force
    Write-Host "Created repositories directory at: $RepositoriesPath" -ForegroundColor Green
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Test-GitAvailability {
    try {
        $null = git --version
        return $true
    } catch {
        Write-Log "Git is not available in PATH" "ERROR"
        return $false
    }
}

function Test-GhAvailability {
    try {
        $null = gh --version
        return $true
    } catch {
        Write-Log "GitHub CLI (gh) is not available in PATH" "WARN"
        return $false
    }
}

function Initialize-PreDebugging {
    Write-Log "Running pre-debugging checks..." "INFO"
    
    $issues = @()
    
    # Check Git availability
    if (-not (Test-GitAvailability)) {
        $issues += "Git not found in PATH"
    }
    
    # Check GitHub CLI
    if (-not (Test-GhAvailability)) {
        $issues += "GitHub CLI not found (consider installing: winget install GitHub.cli)"
    }
    
    # Check for large files that might cause issues
    if (Test-Path $RepositoriesPath) {
        $largeFiles = Get-ChildItem -Path $RepositoriesPath -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 100MB }
        if ($largeFiles) {
            $issues += "Large files detected that may cause Git issues: $($largeFiles.Count) files > 100MB"
        }
    }
    
    # Check disk space
    $drive = Get-PSDrive -Name (Split-Path $RepositoriesPath -Qualifier).TrimEnd(':')
    $freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)
    if ($freeSpaceGB -lt 5) {
        $issues += "Low disk space: ${freeSpaceGB}GB remaining"
    }
    
    if ($issues.Count -eq 0) {
        Write-Log "All pre-debugging checks passed" "SUCCESS"
    } else {
        Write-Log "Issues detected:" "WARN"
        $issues | ForEach-Object { Write-Log "  - $_" "WARN" }
    }
    
    return $issues.Count -eq 0
}

function Set-DefaultGitConfig {
    Write-Log "Configuring Git defaults for Wooden.Ghost workflow..." "INFO"
    
    # Configure Git settings for better workflow
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.autocrlf true
    
    # Create global gitignore for common patterns
    $globalGitignore = @(
        "# Wooden.Ghost Global Gitignore",
        "",
        "# OS generated files",
        ".DS_Store",
        ".DS_Store?",
        "._*",
        ".Spotlight-V100",
        ".Trashes",
        "ehthumbs.db",
        "Thumbs.db",
        "",
        "# IDE files",
        ".vscode/settings.json",
        ".idea/",
        "*.swp",
        "*.swo",
        "",
        "# Temporary files",
        "*.tmp",
        "*.temp",
        "*~",
        "",
        "# Large media files",
        "*.wav",
        "*.mp3",
        "*.flac",
        "*.mov",
        "*.mp4",
        "*.avi",
        "",
        "# Logs",
        "*.log",
        "npm-debug.log*",
        "yarn-debug.log*",
        "yarn-error.log*"
    )
    
    $gitignorePath = Join-Path $env:USERPROFILE ".gitignore_global"
    $globalGitignore | Out-File -FilePath $gitignorePath -Encoding UTF8
    git config --global core.excludesfile $gitignorePath
    
    Write-Log "Git configuration updated" "SUCCESS"
}

function New-RepositoryWorkspace {
    param([string]$Name)
    
    if (-not $Name) {
        Write-Log "Repository name required" "ERROR"
        return
    }
    
    $repoPath = Join-Path $RepositoriesPath $Name
    
    if (Test-Path $repoPath) {
        Write-Log "Repository directory already exists: $repoPath" "WARN"
        return
    }
    
    # Pre-debugging check
    if (-not (Initialize-PreDebugging)) {
        Write-Log "Pre-debugging failed. Please address issues before creating repository." "ERROR"
        return
    }
    
    # Create repository directory
    New-Item -ItemType Directory -Path $repoPath -Force | Out-Null
    Set-Location $repoPath
    
    # Initialize Git repository
    git init
    
    # Create initial structure for Temporal.Optimization projects
    $structure = @(
        "src",
        "docs", 
        "tests",
        "assets",
        "temporal-optimization"
    )
    
    foreach ($dir in $structure) {
        New-Item -ItemType Directory -Path (Join-Path $repoPath $dir) -Force | Out-Null
    }
    
    # Create README with Wooden.Ghost template
    $readmeContent = @(
        "# $Name",
        "",
        "Part of the Wooden.Ghost Temporal.Optimization research framework.",
        "",
        "## Overview",
        "",
        "This repository contains research and implementations related to temporal optimization,",
        "quantum coherence effects, and collective intelligence emergence.",
        "",
        "## Structure",
        "",
        "- \`src/\` - Source code and implementations",
        "- \`docs/\` - Documentation and research notes", 
        "- \`tests/\` - Testing frameworks and validation",
        "- \`assets/\` - Media, visualizations, and resources",
        "- \`temporal-optimization/\` - Core temporal optimization algorithms",
        "",
        "## Wooden.Ghost Framework",
        "",
        "This work is part of the broader Temporal.Optimization research exploring:",
        "",
        "- Synchronization of collective consciousness",
        "- Quantum coherence in information processing", 
        "- Evolution of communication frameworks",
        "- Emergence of artificial intelligence through temporal patterns",
        "",
        "---",
        "",
        "*Created with Wooden.Ghost GitHub workflow tools*"
    )
    
    $readmeContent | Out-File -FilePath (Join-Path $repoPath "README.md") -Encoding UTF8
    
    # Initial commit
    git add .
    git commit -m "Initial commit: Wooden.Ghost repository structure"
    
    Write-Log "Repository '$Name' created successfully at $repoPath" "SUCCESS"
}

function Show-RepositoryStatus {
    Write-Log "Wooden.Ghost Repository Status" "INFO"
    Write-Log "Root: $WoodenGhostRoot" "INFO"
    Write-Log "Repositories: $RepositoriesPath" "INFO"
    
    if (Test-Path $RepositoriesPath) {
        $repos = Get-ChildItem -Path $RepositoriesPath -Directory
        Write-Log "Found $($repos.Count) repositories:" "INFO"
        
        foreach ($repo in $repos) {
            $gitPath = Join-Path $repo.FullName ".git"
            $isGitRepo = Test-Path $gitPath
            $status = if ($isGitRepo) { "Git Repo" } else { "Directory" }
            Write-Log "  $($repo.Name) - $status" "INFO"
        }
    } else {
        Write-Log "Repositories directory not found" "WARN"
    }
}

function Invoke-QuickFix {
    Write-Log "Running quick fixes for common issues..." "INFO"
    
    if (-not (Test-Path $RepositoriesPath)) {
        Write-Log "Repositories directory not found, creating it..." "INFO"
        New-Item -ItemType Directory -Path $RepositoriesPath -Force | Out-Null
    }
    
    # Clean up temporary files
    Get-ChildItem -Path $RepositoriesPath -Recurse -Include "*.tmp", "*.temp", "*~" -ErrorAction SilentlyContinue | Remove-Item -Force
    
    # Update all Git repositories
    Get-ChildItem -Path $RepositoriesPath -Directory | ForEach-Object {
        $gitPath = Join-Path $_.FullName ".git"
        if (Test-Path $gitPath) {
            Set-Location $_.FullName
            Write-Log "Updating repository: $($_.Name)" "INFO"
            git fetch --all --prune 2>$null
            git gc 2>$null
        }
    }
    
    Write-Log "Quick fixes completed" "SUCCESS"
}

# Main execution logic
switch ($Action.ToLower()) {
    "setup" {
        Write-Log "Setting up Wooden.Ghost GitHub workflow..." "INFO"
        Initialize-PreDebugging
        Set-DefaultGitConfig
        Show-RepositoryStatus
    }
    "new" {
        if (-not $RepoName) {
            $RepoName = Read-Host "Enter repository name"
        }
        New-RepositoryWorkspace -Name $RepoName
    }
    "status" {
        Show-RepositoryStatus
    }
    "predebug" {
        Initialize-PreDebugging
    }
    "fix" {
        Invoke-QuickFix
    }
    default {
        Write-Log "Wooden.Ghost GitHub Workflow Tool" "INFO"
        Write-Log "Usage: .\setup_github_workflow.ps1 -Action <action> [-RepoName <name>] [-Debug]" "INFO"
        Write-Log "" "INFO"
        Write-Log "Actions:" "INFO"
        Write-Log "  setup    - Configure GitHub workflow and pre-debugging" "INFO"
        Write-Log "  new      - Create new repository in repositories/ directory" "INFO"
        Write-Log "  status   - Show current repository status" "INFO"
        Write-Log "  predebug - Run pre-debugging checks only" "INFO"
        Write-Log "  fix      - Run quick fixes for common issues" "INFO"
    }
}

# Return to original directory
Set-Location $WoodenGhostRoot 