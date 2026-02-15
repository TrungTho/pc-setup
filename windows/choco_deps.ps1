if (Test-Path "$env:ProgramData\chocolatey\choco.exe") {
    Write-Host "ChocoFound"
}
else {
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco install visualvm -y
choco install zoom -y
choco install googlechrome -y
choco install googledrive -yf
choco install microsoft-edge -y
choco install notion -y
choco install postman -y
choco install dbeaver -y
choco install 7zip -y
choco install unikey -y
choco install notepadplusplus -y
choco install proxyman -y
choco install vscode -y
choco install intellijidea-community -y
choco install intellijidea-ultimate -y
choco install qdir -y
choco install vlc -y
choco install powertoys -y
choco install teracopy -y
choco install foxitreader -y
choco install sharex -y
choco install anki -y
choco install rainmeter -y
