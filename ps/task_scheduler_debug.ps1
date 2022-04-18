$taskName = "Start WSL"

$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction 'SilentlyContinue'


$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -NoExit -file "E:\Dropbox\wsl\ansible-os\ps\start_wsl.ps1"'
$trigger = New-ScheduledTaskTrigger -AtLogon -User $user
$trigger.DELAY = 'PT1M'

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
$settings.ExecutionTimeLimit = 'PT0S'

Register-ScheduledTask -RunLevel Highest -Action $action -Trigger $trigger -User $user -TaskName $taskName -Settings $settings -Description $taskName

