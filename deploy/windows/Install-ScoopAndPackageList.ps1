# Install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# Add scoop buckets
scoopBucketList = @(
    "extras"
) | ForEach-Object { Invoke-Expression ("scoop bucket add " + "$_") }

# Install app list with scoop
scoopAppList = @(
    "winbox"
    "win32yank"
) | ForEach-Object { Invoke-Expression ("scoop install " + "$_") }
