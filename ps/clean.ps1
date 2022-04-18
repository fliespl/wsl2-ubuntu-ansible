wsl --shutdown

Remove-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.50.88 -Confirm:$false
