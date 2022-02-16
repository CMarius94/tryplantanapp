<#

.PARAMETER Start
Starts the docker containers.
 
.PARAMETER Stop
Stops the docker containers.
 
.PARAMETER Reset
Removes the docker containers and the folders of the app, then starts again fresh. Use with caution!
 
.PARAMETER PermanentlyRemove 
Removes the docker containers and the folders of the app. Use with caution!

.EXAMPLE
PS> .\RunPlantanapp.ps1 -Start 
.EXAMPLE
PS> .\RunPlantanapp.ps1 -Stop 
.EXAMPLE
PS> .\RunPlantanapp.ps1 -Reset 
.EXAMPLE
PS> .\RunPlantanapp.ps1 -PermanentlyRemove
.SYNOPSIS
This script helps you start / stop / init / reset your app docker containers.
#> 
Param (
    [Parameter(Mandatory=$false)][switch]$Start = $false,
    [Parameter(Mandatory=$false)][switch]$Stop = $false,
    [Parameter(Mandatory=$false)][switch]$Reset = $false,
    [Parameter(Mandatory=$false)][switch]$PermanentlyRemove = $false
)

$ErrorActionPreference = 'Stop'
$siteDir = "$PSScriptRoot\wwwroot\"
$dbDir = "$PSScriptRoot\db\"

function StartApp() {
    $alreadyInstalled = $false
    if (-not (Test-Path $siteDir)) {
        New-Item -Type Directory $siteDir
        $alreadyInstalled = $true
    }

    if (-not (Test-Path $dbDir)) {
        New-Item -Type Directory $dbDir
    }

    docker-compose up -d

    if(-not $alreadyInstalled) {
        # Give some time for docker to copy its initial files
        Start-Sleep 5
    }
    Write-Output "Your app container is running."
}

function StopApp() {
    docker-compose stop;
}

function PermanentlyRemoveApp() {
    docker-compose down;

    if (Test-Path $siteDir) {
        Remove-Item $siteDir -Recurse -Force
    }
    if (Test-Path $dbDir) {
        Remove-Item $dbDir -Recurse -Force
    }
}

if ($Start) {
    StartApp
}

if($Stop) {
    StopApp
}

if($PermanentlyRemove) {
    PermanentlyRemoveApp
}

if($Reset) {
    PermanentlyRemoveApp
    Start-Sleep 1
    StartApp
}

if ((-not $Reset) -and (-not $Start) -and (-not $Stop) -and (-not $PermanentlyRemove)) {
    Get-Help $PSCommandPath -Full
}