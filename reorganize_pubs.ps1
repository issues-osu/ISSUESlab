$sourceDir = "content/barboza-pubs"
$destDir = "content/publication"
$files = Get-ChildItem -Path $sourceDir -Filter "*.md"

foreach ($file in $files) {
    # Clean the filename
    $newName = $file.Name -replace "_{{", "-" `
                          -replace "}}_", "-" `
                          -replace "}}", "" `
                          -replace "{{", "" `
                          -replace "'", "" `
                          -replace "_", "-" `
                          -replace "\.", "" `
                          -replace "-md$", ".md" `
                          -replace "--", "-" `
                          -replace "--", "-"

    # Ensure lowercase
    $newName = $newName.ToLower()
    
    # Construct paths
    $sourcePath = $file.FullName
    $destPath = Join-Path $destDir $newName
    
    # Move
    Write-Host "Moving $sourcePath to $destPath"
    Move-Item -Path $sourcePath -Destination $destPath
}

# Remove the source directory if empty
if ((Get-ChildItem $sourceDir).Count -eq 0) {
    Remove-Item -Path $sourceDir
    Write-Host "Removed empty directory $sourceDir"
} else {
    Write-Host "Directory $sourceDir is not empty, not removing."
}
