netsh interface ip add address "vEthernet (WSL)" 192.168.50.88 255.255.255.0

wsl.exe -d ubuntu-20.04 -u flies bash -i -c "exit"

pause