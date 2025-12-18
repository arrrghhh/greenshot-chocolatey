Import-Module Chocolatey-AU

function global:au_GetLatest {
    $repo = "greenshot/greenshot"
    $apiUrl = "https://api.github.com/repos/$repo/releases/latest"
    
    try {
        $release = Invoke-RestMethod -Uri $apiUrl
    }
    catch {
        throw "Could not fetch release from GitHub API. Error: $_"
    }

    $version = $release.tag_name -replace '^v',''
    $asset = $release.assets | Where-Object { $_.name -match 'INSTALLER.*\.exe' } | Select-Object -First 1

    if (-not $asset) {
        throw "Could not find an installer (.exe) in the latest release assets."
    }

    return @{
        Version  = $version
        URL32    = $asset.browser_download_url
        FileType = 'exe'
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`${1}'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum32)'"
        }
        
        ".\greenshot.nuspec" = @{
            "(?i)(<version>)([^<]+)(</version>)" = "`${1}$($Latest.Version)`${3}"
        }
    }
}

Update-Package -ChecksumFor 32