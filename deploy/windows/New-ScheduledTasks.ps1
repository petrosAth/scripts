# Create Task Scheduler tasks

# Run autoHotkeys scripts at user log on
$trigger = New-ScheduledTaskTrigger -AtLogon

$actionAutoHotkey = New-ScheduledTaskAction -Execute "$env:USERPROFILE\.config\autohotkey\autoHotkeyScript.ahk"
$actionAutoHotkeyElevated = New-ScheduledTaskAction -Execute "$env:USERPROFILE\.config\autohotkey\autoHotkeyScriptElevated.ahk"

Register-ScheduledTask -Action $actionAutoHotkey         -Trigger $trigger -TaskName "autoHotkeyScript" `
    -Description "Start autoHotkeyScript at user log on"
Register-ScheduledTask -Action $actionAutoHotkeyElevated -Trigger $trigger -TaskName "autoHotkeyScriptElevated" `
    -Description "Start autoHotkeyScriptElevated at user log on" -RunLevel Highest
