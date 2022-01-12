# Set Windows Symbolic Links #--------------------------------------------------

# Windows Symbolic Links List
# https://superuser.com/a/217506

$SymLinksList = @(
	# PowerShell profile
	[pscustomobject]@{
		origin = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
		target = "$env:USERPROFILE\dotfiles\powershell\Microsoft.PowerShell_profile.ps1"
	}
	# Windows Terminal settings
	[pscustomobject]@{
		origin = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
		target = "$env:USERPROFILE\dotfiles\WindowsTerminal\settings.json"
	}
	# App Installer (winget) settings
	[pscustomobject]@{
		origin = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
		target = "$env:USERPROFILE\dotfiles\winget\settings.json"
	}
	# Alacritty config
	[pscustomobject]@{
		origin = "$env:APPDATA\alacritty\alacritty.yml"
		target = "$env:USERPROFILE\dotfiles\alacritty\alacritty.yml"
	}
	# Git global config
	[pscustomobject]@{
		origin = "$env:USERPROFILE\.gitconfig"
		target = "$env:USERPROFILE\dotfiles\git\config"
	}
	# FileZilla config
	[pscustomobject]@{
		origin = "$env:APPDATA\FileZilla"
		target = "$env:USERPROFILE\dotfiles\FileZilla"
	}
	# Synergy config
	[pscustomobject]@{
		origin = "$env:USERPROFILE\synergy.sgc"
		target = "$env:USERPROFILE\dotfiles\synergy\synergy.sgc"
	}
)

# Set Symbolic Links
# Check if user is admin.
# Without admin rights the script can only delete the origin files without being able to do the symlinks.
if ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'){
    foreach($SymLink in $SymLinksList){
        Remove-Item $SymLink.origin -Recurse -Force
        New-Item -ItemType SymbolicLink -Path $SymLink.origin -Target $SymLink.target
    }
}
else {
    Write-Error -Message "This action requires Administrator rights!"
}
