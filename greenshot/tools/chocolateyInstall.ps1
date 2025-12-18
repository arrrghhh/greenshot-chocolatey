$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://github.com/greenshot/greenshot/releases/download/v1.3.304/Greenshot-INSTALLER-1.3.304-RELEASE.exe'
$checksum = '3b1450f1183d7f272bab8c36c3c093bc74711eb40dcf722852b7361e9ef297c4'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Greenshot*'

  checksum      = $checksum
  checksumType  = 'sha256'
  checksum64    = ''
  checksumType64= 'sha256'

  silentArgs   = '/ALLUSERS /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

