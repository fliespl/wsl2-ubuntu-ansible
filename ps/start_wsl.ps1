if([string]::IsNullOrEmpty($(wsl -l -q --running))) {
	$start = $(wsl -e bash -c "genie -i")
	
	if([string]::IsNullOrEmpty($(wsl -l -q --running))) {
		throw "WSL did not start properly."
	}
}

$output = Get-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.50.88  -PrefixLength 24 -ErrorAction "SilentlyContinue"

if([string]::IsNullOrEmpty($output)) {
	[void] (New-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.50.88  -PrefixLength 24 -ErrorAction "Stop")
}


$output = Get-NetFirewallRule -DisplayName "Allow WSL access" -ErrorAction "SilentlyContinue"

if([string]::IsNullOrEmpty($output)) {
	[void] (New-NetFirewallRule -DisplayName "Allow WSL access" -Direction Inbound -LocalAddress 192.168.50.88 -RemoteAddress 192.168.50.16 -Action Allow -ErrorAction "Stop")
}


$network = 0

for ($i=0; $i -lt 10; $i++) {
	if($(wsl -e bash -c 'ping -c 1 -q 1.1.1.1 > /dev/null 2>&1 ; echo $?') -ne 0) {
		Write-Host "Ping failed with internet. Trying again..."
		Start-Sleep 1
	} else {
		$network = 1
		break
	}
}

if($network -ne 1) {
	throw "Error setting up network."
}

$lan = 0
for ($i=0; $i -lt 3; $i++) {
	if($(wsl -e bash -c 'ping -c 1 -q 192.168.50.88 > /dev/null 2>&1 ; echo $?') -ne 0) {
		Write-Host "Ping failed on LAN interface. Trying again..."
		Start-Sleep 1
	} else {
		$lan = 1
		break
	}
}

if($lan -ne 1) {
	throw "Error setting up LAN network."
}

Write-Host "WSL started successfully."
