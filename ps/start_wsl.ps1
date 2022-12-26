if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator'))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

$Name = "WSL"
$WslSubnet = "192.168.50.0/24"
$WslGatewayIP = "192.168.50.88"
$WslIP = "192.168.50.16"

# Load HnsEx
$CurrentPath = Split-Path $script:MyInvocation.MyCommand.Path -Parent
. $( Join-Path -Path $CurrentPath -ChildPath "HnsEx.ps1" )



$wslNetwork = Get-HnsNetwork | Where-Object { $_.Name -eq $Name }
wsl --shutdown

# Delete existing network
Write-Host "Deleting existing WSL network and other conflicting NAT network ..."
$wslNetwork | Remove-HnsNetwork

# Check WSL network is deleted
$wslNetwork = Get-HnsNetwork | Where-Object { $_.Name -eq $Name }
if ($null -ne $wslNetwork)
{
    $wslNetworkJson = $wslNetwork | ConvertTo-Json
    Throw "Current wslNetwork could not be deleted: $wslNetworkJson"
}

# Destroy WSL network may fail if it happened in the wrong order like if it was done manually
if (Get-VMSwitch -Name $Name -ea "SilentlyContinue")
{
    Throw "One more VMSwitch named $Name remains after destroying WSL network. Please reboot your computer to clean it up."
}

# Delete conflicting NetNat
$wslNetNat = Get-NetNat | Where-Object { $_.InternalIPInterfaceAddressPrefix -Match $AddressPrefix }
$wslNetNat | ForEach-Object { Remove-NetNat -Confirm:$False -Name:$_.Name }

# Create new WSL network
[void] (New-HnsNetwork -Name $Name -AddressPrefix $WslSubnet -GatewayAddress $WslGatewayIP)


if ( [string]::IsNullOrEmpty($( wsl -l -q --running )))
{
    [void] $(wsl -e bash -i -c "pwd" )

    if ( [string]::IsNullOrEmpty($( wsl -l -q --running )))
    {
        throw "WSL did not start properly."
    }
}

$output = Get-NetFirewallRule -DisplayName "Allow WSL access" -ErrorAction "SilentlyContinue"

if ( [string]::IsNullOrEmpty($output))
{
    [void](New-NetFirewallRule -DisplayName "Allow WSL access" -Direction Inbound -LocalAddress $wslGatewayIp -RemoteAddress $wslIp -Action Allow -ErrorAction "Stop")
}


# Allow mobaxterm public profile
foreach ($Rule in Get-NetFirewallRule -DisplayName "xwin_mobax.exe")
{
    Set-NetFirewallRule -Id $Rule.Id -Action Allow
}

$network = 0

for ($i = 0; $i -lt 10; $i++) {
    if ($( wsl -e bash -i -c 'ping -c 1 -q 1.1.1.1 > /dev/null 2>&1 ; echo $?' ) -ne 0)
    {
        Write-Host "Ping failed with internet. Trying again..."
        Start-Sleep 1
    }
    else
    {
        $network = 1
        break
    }
}

if ($network -ne 1)
{
    throw "Error setting up network."
}

$lan = 0
for ($i = 0; $i -lt 3; $i++) {
    $command = 'ping -c 1 -q '
    $command = $command + $WslGatewayIP
    $command = $command + ' > /dev/null 2>&1 ; echo $?'

    if ($( wsl -e bash -i -c $command ) -ne 0)
    {
        Write-Host "Ping failed on LAN interface. Trying again..."
        Start-Sleep 1
    }
    else
    {
        $lan = 1
        break
    }
}

if ($lan -ne 1)
{
    throw "Error setting up LAN network."
}

Write-Host "WSL started successfully."

