#!/usr/sh
# detect OS
echo "=====OS Check=====";
if [ "$(uname)" = "Darwin" ];
then
    echo "MacOS";
    echo "=====Install Homebrew=====";
    which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
    echo "=====Ansible check=====";
    if which ansible > /dev/null 2>&1; then
      echo "Ansible already existed";
    else
      echo "Installing Ansible...";
      brew install ansible
    fi;
else
    uname;
    echo "=====Ansible check=====";
    if which ansible > /dev/null 2>&1; then
      echo "Ansible already existed";
    else
      echo "Installing Ansible...";
      sudo apt update;
      sudo apt install software-properties-common -y;
      sudo add-apt-repository --yes --update ppa:ansible/ansible;
      sudo apt install ansible --yes;
    fi;

    echo "=====Makefile check=====";
    if which make > /dev/null 2>&1; then
      echo "Makefile already existed";
    else
      echo "Installing Makefile...";
      sudo apt install make --yes;
    fi;
fi

make run;