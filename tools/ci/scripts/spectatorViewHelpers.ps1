. $PSScriptRoot\..\..\Scripts\SetupRepositoryFunc.ps1

function SetupToolsPath
{
  param
  (
    $ProjectPath,
    $ToolsAssetsPath
  )

  $projAssets = $ProjectPath + "\Assets"
  $toolsPath = $projAssets + "\BuildTools.Unity"
  If (!(Test-Path $toolsPath))
  {
    $tempLoc = Get-Location
    Set-Location $projAssets
    cmd /c mklink /D "BuildTools.Unity" $ToolsAssetsPath
    Set-Location $tempLoc
  }
}

function DownloadQRCodePlugin
{
  if (!(Test-Path "$PSScriptRoot\..\..\..\external\MixedReality-QRCodePlugin\release"))
  {
    $zipFile = "$PSScriptRoot\..\..\..\external\qrcodeplugin.zip"
    $url = "https://github.com/dorreneb/mixed-reality/releases/download/1.1/release.zip"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $zipFile)
    Expand-Archive -Path $zipFile -DestinationPath "$PSScriptRoot\..\..\..\external\MixedReality-QRCodePlugin" -Force
  }
  else
  {
    Write-Host "external/MixedReality-QRCodePlugin already populated in repo"
  }
}

function DownloadARKitPlugin
{
  if (!(Test-Path "$PSScriptRoot\..\..\..\external\ARKit-Unity-Plugin\Unity-Technologies-unity-arkit-plugin-94e47eae5954"))
  {
    $zipFile = "$PSScriptRoot\..\..\..\external\unity-arkit-plugin.zip"
    $url = "https://bitbucket.org/Unity-Technologies/unity-arkit-plugin/get/94e47eae5954.zip"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $zipFile)
    Expand-Archive -Path $zipFile -DestinationPath "$PSScriptRoot\..\..\..\external\ARKit-Unity-Plugin" -Force
  }
  else
  {
    Write-Host "external/ARKit-Unity-Plugin already populated in repo."
  }
}

function SetupDependencies
{
  DownloadQRCodePlugin
  DownloadARKitPlugin
  SetupRepository
}

function HideUnityAssetsDirectory
{
    param
    (
      $Path
    )

    if (Test-Path $Path)
    {
       $Leaf = Split-Path -Path $Path -Leaf
       $NewLeaf = ".$Leaf"
       Rename-Item -Path $Path -NewName $NewLeaf
    }
}

function IncludeUnityAssetsDirectory
{
    param
    (
      $Path
    )

    if (Test-Path $Path)
    {
       $Leaf = Split-Path -Path $Path -Leaf
       $NewLeaf = $Leaf.TrimStart(".")
       Rename-Item -Path $Path -NewName $NewLeaf
    }
}

function HideAndroidAssets
{
   param
   (
     $ProjectPath
   )

   HideUnityAssetsDirectory -Path "$ProjectPath\Assets\GoogleARCore"
}

function IncludeAndroidAssets
{
   param
   (
     $ProjectPath
   )

   IncludeUnityAssetsDirectory -Path "$ProjectPath\Assets\.GoogleARCore"
}

function HideIOSAssets
{
   param
   (
     $ProjectPath
   )

   HideUnityAssetsDirectory -Path "$ProjectPath\Assets\ARKit-Unity-Plugin"
}

function IncludeIOSAssets
{
   param
   (
     $ProjectPath
   )

   IncludeUnityAssetsDirectory -Path "$ProjectPath\Assets\.ARKit-Unity-Plugin"
}

function HideASAAssets
{
   param
   (
     $ProjectPath
   )

   HideUnityAssetsDirectory -Path "$ProjectPath\Assets\AzureSpatialAnchorsPlugin"
   HideUnityAssetsDirectory -Path "$ProjectPath\Assets\AzureSpatialAnchors.Resources"
}

function IncludeASAAssets
{
   param
   (
     $ProjectPath
   )

   IncludeUnityAssetsDirectory -Path "$ProjectPath\Assets\.AzureSpatialAnchorsPlugin"
   IncludeUnityAssetsDirectory -Path "$ProjectPath\Assets\.AzureSpatialAnchors.Resources"
}

function HideQRCodePlugin
{
   param
   (
     $ProjectPath
   )

   HideUnityAssetsDirectory -Path "$ProjectPath\Assets\MixedReality-QRCodePlugin"
}

function IncludeQRCodePlugin
{
   param
   (
     $ProjectPath
   )

   IncludeUnityAssetsDirectory -Path "$ProjectPath\Assets\.MixedReality-QRCodePlugin"
}