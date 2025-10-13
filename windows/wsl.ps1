# 1. Enable the main WSL feature
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

# 2. Enable the Virtual Machine Platform feature (required for WSL 2)
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

wsl --install -d Ubuntu
