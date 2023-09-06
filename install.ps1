# if olive-cli already exists, ask if the user wants to replace it
$oliveCliPath = "$env:PROGRAMFILES\olive-cli";
if (Test-Path $oliveCliPath) {
    $userInput = Read-Host -Prompt "The olive-cli.exe exists. Would you like to replace? (y/n)"
    if (!($userInput -eq 'y' -or $userInput -eq 'Y')) {
        Write-Output "Installation canceled..."
        exit
    }
}

# Get latest release and get Asset URL
$latest_release_url = "https://api.github.com/repos/kakao/olive-cli/releases/latest";
$release = Invoke-RestMethod -Uri $latest_release_url;
$assets = $release.assets;
$assetUrl = $release.assets.browser_download_url | Where-Object { $_ -like "*Windows*" }

# Downalod olive-cli zip file
Write-Output "Downloading from: $assetUrl"
$currentDir = Get-Location
Invoke-WebRequest -Uri $assetUrl -OutFile "$currentDir\olive-cli.zip"

# Extract the downloaded file
Write-Output "Extract file: $currentDir\olive-cli.zip"
Expand-Archive -Path "$currentDir\olive-cli.zip" -DestinationPath $currentDir -Force


# Make olive-cli directory if not exists.
$destinationPath = "$env:PROGRAMFILES\olive-cli"
if (!(Test-Path -Path $destinationPath )) {
    # if not, create the directory
    Write-Output "Create olive-cli folder in C:\Program Files"
    New-Item -ItemType Directory -Force -Path $destinationPath
    Write-Output ""
}


# Move olive-cli to Program Files
Write-Output "Move olive-cli.exe to C:\Program Files\olive-cli."
Move-Item -Path $currentDir/olive-cli.exe -Destination $destinationPath -Force
Move-Item -Path $currentDir/NOTICE.md -Destination $destinationPath -Force

# Get the current PATH variable
$path = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Add olive.exe if path does not contain olive.exe
if ($currentPath -notlike "*$destinationPath*") {
    # append the program path to the current PATH
    $newPath = $path + ";" + "$destinationPath";

    # set the new PATH permanently
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

    # set the new PATH for the current session
    $env:Path = $newPath
}


# Remove the downloaded files
Write-Output "Remove $currentDir\olive-cli.zip"
if (Test-Path -Path $currentDir\olive-cli.zip) {
    # if yes, delete the file
    Remove-Item -Path $currentDir\olive-cli.zip
}

try {
    $path = (Get-Command olive-cli).Source
    Write-Output "Installation completed successfully."
}
catch {
    Write-Output "Installation failed."
}
