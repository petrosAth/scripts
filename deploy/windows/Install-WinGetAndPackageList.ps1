# Script description #----------------------------------------------------------
# Check if winget-cli is present and if it is install listed apps.
# If it isn't, download and install latest release from github and then
# install listed apps

# Sources #---------------------------------------------------------------------
# https://gist.github.com/MarkTiedemann/c0adc1701f3f5c215fc2c2d5b1d5efd3
# https://gist.github.com/Codebytes/29bf18015f6e93fca9421df73c6e512c

# Try to skip import Appx module if not needed
try {
    $hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
}
catch {
    Import-Module -Name Appx -UseWIndowsPowershell # Source: https://github.com/PowerShell/PowerShell/issues/14057#issuecomment-726090361
    $hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
}

# Check if winget is already installed. If not install it.
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.16.0.0") {
    $repo = "microsoft/winget-cli"
    $file = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

    $releases = "https://api.github.com/repos/$repo/releases"

    Write-Host Determining latest release
    $tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

    Write-Host Installing winget-cli $tag
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Add-AppPackage -path "https://github.com/$repo/releases/download/$tag/$file"
}
else {
    "winget-cli already installed"
}

# Install apps
Write-Host "Installing Apps"
$apps = @(
    @{name = "Microsoft.PowerShell"            }, # Development #---------------
    @{name = "Microsoft.WindowsTerminal"       },
    @{name = "Python.Python.3"                 },
    @{name = "Git.Git"                         },
    @{name = "GitHub.cli"                      },
    @{name = "JanDeDobbeleer.OhMyPosh"         },
    @{name = "Microsoft.VisualStudioCode"      },
    @{name = "UnityTechnologies.UnityHub"      },
    @{name = "Notepad++.Notepad++"             },
    @{name = "Microsoft.PowerToys"             }, # Utilities #-----------------
    @{name = "9NGHP3DX8HDX"; source = "msstore"}, # Files file manager
    @{name = "Logitech.GHUB"                   },
    @{name = "AppWork.JDownloader"             },
    @{name = "KeePassXCTeam.KeePassXC"         },
    @{name = "Bitwarden.Bitwarden"             },
    @{name = "7zip.7zip"                       },
    @{name = "Rufus.Rufus"                     },
    @{name = "Lexikos.AutoHotkey"              },
    @{name = "Nextcloud.NextcloudDesktop"      }, # Remote & Cloud #------------
    @{name = "TimKosse.FileZilla.Client"       },
    @{name = "TeamViewer.TeamViewer"           },
    @{name = "Levitsky.FontBase"               }, # Editing --------------------
    @{name = "HandBrake.HandBrake"             },
    @{name = "BlenderFoundation.Blender"       },
    @{name = "Avidemux.Avidemux"               },
    @{name = "Audacity.Audacity"               },
    @{name = "brrd.abricotine"                 }, # Markdown editor
    @{name = "Mozilla.Thunderbird"             }, # Web & Chat #----------------
    @{name = "Mozilla.Firefox"                 },
    @{name = "9WZDNCRF0083"; source = "msstore"}, # Messenger
    @{name = "Viber.Viber"                     },
    @{name = "VideoLAN.VLC"                    }, # Entertainment #-------------
    @{name = "Valve.Steam"                     },
    @{name = "9WZDNCRFJ3TJ"; source = "msstore"}, # Netflix
    @{name = "Plex.Plex"                       },
    @{name = "Spotify.Spotify"                 }
);
Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.name
        if ($app.source -ne $null) {
            winget install --exact --silent $app.name --source $app.source
        }
        else {
            winget install --exact --silent $app.name
        }
    }
    else {
        Write-host "Skipping Install of " $app.name
    }
}
