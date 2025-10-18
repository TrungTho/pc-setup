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
    echo "=====User check=====";
    if [ "$EUID" -ne 0 ]; then
      echo "root user is required to run the script";
      exit 1;
    fi;

    echo "=====Ansible check=====";
    if which ansible > /dev/null 2>&1; then
      echo "Ansible already existed";
    else
      echo "Installing Ansible...";
      apt update;
      apt install software-properties-common -y;
      add-apt-repository --yes --update ppa:ansible/ansible;
      apt install ansible --yes;
    fi;

    echo "=====Makefile check=====";
    if which make > /dev/null 2>&1; then
      echo "Makefile already existed";
    else
      echo "Installing Makefile...";
      apt install make --yes;
    fi;
fi

make run;