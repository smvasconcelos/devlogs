# PowerShell Script for Windows

# Set variables for Obsidian to Hugo copy
$sourcePath = 'D:\obsidian\Blog\Posts'
$destinationPath = 'D:\Programming\blog\content\posts'
$blogPath = 'D:\Programming\blog'

# Set Github repo
$myrepo = 'https://github.com/smvasconcelos/devlogs'

# Set error handling
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Change to the script's directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

# Check for required commands
$requiredCommands = @('git', 'hugo')

# Check for Python command (python or python3)
if (Get-Command 'python' -ErrorAction SilentlyContinue) {
    $pythonCommand = 'python'
} elseif (Get-Command 'python3' -ErrorAction SilentlyContinue) {
    $pythonCommand = 'python3'
} else {
    Write-Error 'Python is not installed or not in PATH.'
    exit 1
}

foreach ($cmd in $requiredCommands) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Error '$cmd is not installed or not in PATH.'
        exit 1
    }
}

# Step 1: Sync posts from Obsidian to Hugo content folder with language suffix
Write-Host 'Syncing posts from Obsidian...'

if (-not (Test-Path $sourcePath)) {
    Write-Error 'Source path does not exist: $sourcePath'
    exit 1
}

if (-not (Test-Path $destinationPath)) {
    Write-Error 'Destination path does not exist: $destinationPath'
    exit 1
}

# Step 2: Define supported language subfolders
$languages = @('en', 'pt')

foreach ($lang in $languages) {
    $langSource = Join-Path $sourcePath $lang

    if (-not (Test-Path $langSource)) {
        Write-Warning "Language folder not found: $langSource"
        continue
    }

    Write-Host "Processing language: $lang"

    # Get all Markdown files in the language folder
    Get-ChildItem -Path $langSource -Filter *.md -Recurse | ForEach-Object {
        $fileName = $_.BaseName
        $safeFileName = ($fileName -replace '\s+', '-').ToLower()

        # === Gera hash curto e consistente ===
        $hash = [System.Security.Cryptography.SHA256]::Create()
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($safeFileName)
        $hashBytes = $hash.ComputeHash($bytes)
        $shortHash = -join ($hashBytes[0..7] | ForEach-Object { $_.ToString("x2") })  # 16 caracteres hexadecimais

        # Cria nome de destino com hash
        $destFile = Join-Path $destinationPath "$shortHash.$lang.md"

        # Copia o arquivo com novo nome
        Copy-Item -Path $_.FullName -Destination $destFile -Force
        Write-Host "Copied: $safeFileName as $shortHash.$lang.md"
    }
}

Write-Host 'Sync posts complete — files renamed by language.'

# Step 3: Process Markdown files with Python script to handle image links
Write-Host 'Processing image links in Markdown files...'
if (-not (Test-Path 'images.py')) {
    Write-Error 'Python script images.py not found.'
    exit 1
}

# Execute the Python script
try {
    & $pythonCommand images.py
} catch {
    Write-Error 'Failed to process image links.'
    exit 1
}

# Finishing build , indexing and git flow, we only need to be at the blog repository
Set-Location $blogPath

# Step 4: Build the Hugo site
Write-Host 'Building the Hugo site...'
try {
    # Change to Hugo site folder
    Set-Location $blogPath

    # Run Hugo build
    hugo

    Write-Host 'Indexing search files...'

    # npx pagefind --site public --glob "**/posts/*.html"
    npx pagefind --site public
} catch {
    Write-Error 'Hugo build failed.'
    exit 1
}


# Step 5: Add changes to Git
Write-Host 'Staging changes for Git...'

$hasChanges = (git status --porcelain) -ne ''

if (-not $hasChanges) {
    Write-Host 'No changes to stage.'
} else {
    git add .
}

# Step 6: Commit changes with a dynamic message
$commitMessage = "post: New Blog Post on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

$hasStagedChanges = (git diff --cached --name-only) -ne ''

if (-not $hasStagedChanges) {
    Write-Host 'No changes to commit.'
} else {
    Write-Host 'Committing changes...'
    git commit -m "$($commitMessage)"
}

# Step 7: Push all changes to the main branch
Write-Host 'Deploying to GitHub Main...'

try {
    git push origin main
} catch {
    Write-Error 'Failed to push to Main branch.'
    exit 1
}

Write-Host 'All done! Site synced, processed, committed, built, and deployed.'
