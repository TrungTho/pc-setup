#!/usr/sh
# install brew first
which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
brew install --cask iterm2;
brew install zsh-completions;

# k8s related tools
brew install kubectl && echo "source <(kubectl completion zsh)" >> ~/.zshrc;
brew install kubectx;
brew install helm;
brew install derailed/k9s/k9s;
which istioctl ||  curl -sL https://istio.io/downloadIstioctl | sh - && export PATH=$HOME/.istioctl/bin:$PATH

# install useful applications
## via homebrew
brew install --cask zoom;
brew install --cask google-chrome;
brew install --cask aerial;
brew install --cask notion;
brew install --cask postman;
brew install --cask docker;
brew install --cask dbeaver-community;
brew install --cask keka;
brew install --cask openkey;
brew install --cask microsoft-edge;
brew install pstree;
brew install sysdig;
brew install jq;
brew install ansible;
brew install zig;
# brew install --cask karabiner-elements;
#brew install --cask microsoft-outlook;

## via appstore
### install mas first
brew install mas;

### login to appstore first time
mas reset;
mas signin --dialog thott2.gdf4@gmail.com;
mas reset;

mas list | grep 'Apnea' || mas install 1216253186;
mas list | grep 'CopyClip' || mas install 595191960;
mas list | grep 'PomoDone' || mas install 1096128050;
mas list | grep 'Rad Timer' || mas install 6461776692;
mas list | grep 'Irvue' || mas install 1039633667;
mas list | grep 'Tayasui Sketches' || mas install 1178074963;
mas list | grep 'MasDroid' || mas install 1476545828;

# install developer tools
brew install git;
brew install --cask proxyman;
 brew install vegeta;
brew install podman;
brew install liquibase;
brew install sqlc;
brew install protobuf;

# install language runtimes
## Golang
brew install go;
brew install golang-migrate;

## NodeJS
brew install nvm;
nvm install 18.12.1;

## sdk and Java17
sdk version || curl -s "https://get.sdkman.io" | bash && source "/Users/$USER/.sdkman/bin/sdkman-init.sh";
java --version || sdk install java 17.0.7-tem;

## correct gradle version -> run
if [ $(gradle --version | grep "7.6.1" | wc -l) -eq 1 ]; then
  echo "=== correct gradle version detected ===";
else
  echo "=== install gradle ===";
  sdk install gradle 7.6.1;
  sdk use gradle 7.6.1;
fi
;

brew install --cask visualvm;

# install IDE
brew install --cask visual-studio-code;
brew install --cask intellij-idea-ce;

# additional set up
## set up vi
cat <<EOT >> ~/.vimrc
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set ic
syntax on
filetype on
EOT
;

## set up alias
grep "alias grep="  ~/.zshrc || echo  "alias grep='grep --color=auto'" >>  ~/.zshrc
grep "alias ll="  ~/.zshrc || echo  "alias ll='ls -al'" >>  ~/.zshrc
grep "alias dcp="  ~/.zshrc || echo  "alias dcp='docker-compose'" >>  ~/.zshrc
grep "alias ter="  ~/.zshrc || echo  "alias ter='terraform'" >>  ~/.zshrc
grep "alias pwsleep="  ~/.zshrc || echo  "alias pwsleep='pmset sleepnow'" >>  ~/.zshrc
grep "alias mks="  ~/.zshrc || echo  "alias mks='minikube'" >>  ~/.zshrc
grep "alias k="  ~/.zshrc || echo  "alias k='kubectl'" >>  ~/.zshrc
grep "alias mergemain="  ~/.zshrc || echo  "alias mergemain='git fetch origin main:main && git merge main'" >>  ~/.zshrc
grep "alias greset="  ~/.zshrc || echo  "alias greset='git reset --hard'" >>  ~/.zshrc
grep "alias gundo="  ~/.zshrc || echo  "alias gundo='git reset HEAD~'" >>  ~/.zshrc
grep "alias gcurr="  ~/.zshrc || echo  "alias gcurr='git branch | grep '*''" >>  ~/.zshrc
grep "alias gmain="  ~/.zshrc || echo  "alias gmain='git checkout main && git pull'" >>  ~/.zshrc
grep "alias wk="  ~/.zshrc || echo  "alias wk='watch kubectl'" >>  ~/.zshrc
grep "alias gitgrep="  ~/.zshrc || echo  "alias gitgrep='git branch | grep '" >>  ~/.zshrc
grep "alias py="  ~/.zshrc || echo  "alias py='python3'" >>  ~/.zshrc
grep "alias pip="  ~/.zshrc || echo  "alias pip='pip3'" >>  ~/.zshrc
grep "alias g="  ~/.zshrc || echo  "alias g='gcloud'" >>  ~/.zshrc
