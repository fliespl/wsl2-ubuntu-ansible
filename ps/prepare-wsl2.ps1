if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" +$myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

if([System.Environment]::OSVersion.Version.Build -lt 18836) {
    throw "Windows build 18836 or higher is required."
}

$restart = $false

if($(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V").State -ne "Enabled") {
    Write-Host "Installing Hyper-V"
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V" -NoRestart -All
    $restart = $true
}

if($(Get-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform").State -ne "Enabled") {
    Write-Host "Installing VirtualMachinePlatform"
    Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -NoRestart -All
    $restart = $true
}

if($(Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -ne "Enabled") {
    Write-Host "Installing Microsoft-Windows-Subsystem-Linux"
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -All
    $restart = $true
}

if($restart -eq $true) {
    Write-Host "Restart required for WSL to work properly"
    Restart-Computer -Confirm:$true
} else {
    Write-Host "All good! :)"
}
