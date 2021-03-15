This project is still WIP. Errors can happen every now and then.

## Windows
1. Install clean ubuntu-20.04 (or debian) as wsl2
2. Execute `setup_wsl_ip.bat` to assign static IP on Windows host for WSL interface.
3. Import two jobs from task-scheduler directory into Windows Task Scheduler:
   - On General tab: Update "When running the task, use the following user account: " to your account
   - On Actions tab: Update .bat file location
   - If needed - update startup_script.bat with your distro name + wsl.exe path
4. Add to Windows hosts file: `192.168.50.16 pma.wsl phpinfo7.4.wsl phpinfo8.0.wsl mailhog.wsl` so you can access various services via domain

### WSL2
1. Login into wsl2 (typicall `wsl` or `wsl -d distro-name`) and execute:
    ```
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install git
    
    git clone git@github.com:fliespl/wsl2-ubuntu20.04-ansible.git
    cd wsl2-ubuntu20.04-ansible
    ```
2. Setup vars in vars/ directory from .dist's
3. Run playbook
    ```
    ansible-playbook local.yml
    ```

### Troubleshooting
1. Restart Windows to check if everything goes up correctly.
2. `ping 192.168.50.16` to check if WSL machine responds.
3. Check if task scheduler jobs are setup correctly (user + .bat files locations) - i.e. close WSL and trigger them manually from task scheduler.