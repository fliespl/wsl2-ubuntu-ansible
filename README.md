This project is still WIP. Errors can happen every now and then.


### WSL2
1. Install clean wsl instance (ubuntu)
2. Login into wsl2 (`wsl` or `wsl -d distro-name`) and execute:
    ```
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install git
    
    git clone git@github.com:fliespl/wsl2-ubuntu20.04-ansible.git
    cd wsl2-ubuntu20.04-ansible
    ```
3. Setup vars in vars/ directory from .dist's
4. Run playbook
    ```
    ansible-playbook local.yml
    ```

## Windows
1. Add to Windows hosts file: `192.168.50.16 pma.wsl phpinfo7.4.wsl phpinfo8.0.wsl mailhog.wsl` so you can access various services via domain
   1. change IP if you used something else in vars file
2. Make sure following options are set in .wslconfig in C:\Users\<USER>\.wslconfig

```
[wsl2]
localhostForwarding=false
guiApplications=false # do not set if you want to use builtin wslg
swap=0 # recommended
```

## Start WSL2 manually
1. Run `wsl` or `wsl -d distro-name`
2. Setup static IP (only required once per Windows reboot):
   1. Start elevated powershell - right click start menu "Windows PowerShell (Admin)"
   2. Execute `New-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.50.88  -PrefixLength 24`
   3. Check `ping 192.168.50.16` from Windows machine

## Start WSL2 and setup static IP on login
1. Run `PowerShell.exe -ExecutionPolicy ByPass -Scope LocalMachine`
3. Execute `setup_wsl_ip.bat` to assign static IP on Windows host for WSL interface.
4. Import two jobs from task-scheduler directory into Windows Task Scheduler:
   - On General tab: Update "When running the task, use the following user account: " to your account
   - On Actions tab: Update .bat file location
   - If needed - update startup_script.bat with your distro name + wsl.exe path
5. 


### Troubleshooting
1. Restart Windows to check if everything goes up correctly.
2. `ping 192.168.50.16` to check if WSL machine responds.
3. Check if task scheduler jobs are setup correctly (user + .bat files locations) - i.e. close WSL and trigger them manually from task scheduler.
