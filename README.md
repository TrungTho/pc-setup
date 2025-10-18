### Preface

This is repository is used to keep all the necessary dependencies for my PC. It mostly utilize the power of ansible for Configuration as Code (except for Windows machine in which a powershell script may be the most straightforward way).

### How to use

#### For MacOSX/Ubuntu OS

- Clone the repository.
- Using command `sh init.sh` to trigger the installation (**with `root` permission on Ubuntu**).

#### For Window OS

- Open powershell with `Administrators` permission.
- Run the `windows/choco_deps.ps1` script to install Chocolatey and GUI applications.
- Run the `windows/wsl.ps1` script to enable WSL and install the Ubuntu WSL machine.
- Using command `wsl` to exec into the WSL machine, and follow the [Ubuntu section](#for-macosxubuntu-os) to install all the Ubuntu dependencies.

### Folder Structure Explanation

- **`clouds/`**: Contains all IaC code to spin up public instances (for testing purpose).
  - **`vm.tf`**: IaC code to spin up EC2 instance.
  - **`aws-ss0.sh`**: Utility script for AWS SSO.
- **`files/`**: Reference/Configuration files for playbook usage.
  - **`vi.cfg`**: Preferred vi configuration.
- **`group_vars/`**: Ansible `group_vars` directory.
  - **`all.yml`**: Reusable variables across playbooks.
- **`inventories/`**: Ansible `inventories` directory.
  - **`raw.yml`**: Normal, default inventory.
- **`roles/`**: Ansible `roles` directory.
  - **`aws_cli/`**: role to install `aws cli`.
  - **`java/`**: role to install `sdkman`, `java` and `gradle`.
- **`vars/`**: Ansible `vars` directory.
- **`windows/`**: powershell scripts which use chocolatey to install GUI applications and enable WSL on windows machine.
- **`Makefile`**: Makefile utility for development.
- **`ansible.cfg`**: Ansible `configuration` file.
- **`deps-installation.yml`**: Main playbook for dependencies installations.
- **`init.sh`**: ONe-line command to set up PC on Ubuntu/MacOSX.
