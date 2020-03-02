#!/bin/sh

# Color Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Ask for the administrator password upfront.
sudo -v

# Keep Sudo Until Script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check if OSX Command line tools are installed
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
    test -d "${xpath}" && test -x "${xpath}" ; then
    ###############################################################################
    # Computer Settings                                                           #
    ###############################################################################
    echo -e "${RED}Enter your computer name please?${NC}"
    read cpname
    echo -e "${RED}Please enter your name?${NC}"
    read name
    echo -e "${RED}Please enter your git email?${NC}"
    read email

    clear

    sudo scutil --set ComputerName "$cpname"
    sudo scutil --set HostName "$cpname"
    sudo scutil --set LocalHostName "$cpname"
    defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$cpname"

    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write NSGlobalDomain KeyRepeat -int 0.02
    defaults write NSGlobalDomain InitialKeyRepeat -int 12
    chflags nohidden ~/Library

    git config --global user.name "$name"

    git config --global user.email "$email"

    git config --global color.ui true

    ###############################################################################
    # Install Applications                                                        #
    ###############################################################################

    # Install Homebrew

    if [ ! -x "$(command -v brew)" ]; then
      echo "Installing Homebrew"
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    clear

    # Install Homebrew Apps
    echo "Installing Homebrew Command Line Tools"
    brew install \
    tree \
    wget \
    ack \
    heroku-toolbelt \
    vim \
    nvim \
    the_silver_searcher \
    curl \
    mas

    mas install 406056744 #Evernote
    mas install 1333542190 #1Password
    mas install 409201541 #Pages
    mas install 409183694 #Keynote
    mas install 409203825 #Numbers
    mas install 1320666476 #Wipr
    mas install 1176895641 #Spark
    mas install 417375580 #BetterSnapTool
    mas install 457622435 #Yoink
    mas install 747648890 #Telegram
    mas install 803453959 #Slack

    echo "Installing Brew Cask Apps"
    brew cask install \
    alfred \
    anaconda \
    atom \
    bartender \
    bettertouchtool \
    firefox \
    google-chrome \
    istat-menus \
    iterm2 \
    jetbrains-toolbox \
    keepingyouawake \
    keyboard-maestro \
    mono-mdk \
    oni \
    sharemouse \
    sourcetree \
    sublime-text \
    typinator \
    virtualbox \
    visual-studio-code

    clear

    echo "Changing dock default apps"
    curl -o /tmp/dock-icon-remove.py https://raw.githubusercontent.com/ceeeeej/osx-dock-remover/master/dock-icon-remove.py

    python /tmp/dock-icon-remove.py -r "Siri"
    python /tmp/dock-icon-remove.py -r "Books"
    python /tmp/dock-icon-remove.py -r "FaceTime"
    python /tmp/dock-icon-remove.py -r "iTunes"
    python /tmp/dock-icon-remove.py -r "App Store"
    python /tmp/dock-icon-remove.py -r "Feedback"
    python /tmp/dock-icon-remove.py -r "System"
    python /tmp/dock-icon-remove.py -r "Reminders"
    python /tmp/dock-icon-remove.py -r "Notes"
    python /tmp/dock-icon-remove.py -r "Launchpad"
    python /tmp/dock-icon-remove.py -r "Contacts"
    python /tmp/dock-icon-remove.py -r "Photos"
    python /tmp/dock-icon-remove.py -r "Maps"
    python /tmp/dock-icon-remove.py -r "Calendar"

    killall Dock

    clear

    echo "Cleaning Up Cask Files"
    brew cask cleanup

    clear

    echo "Changing shell to zsh"
    chsh -s /bin/zsh

    echo "Install oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    clear

    echo "${GREEN}Thanks for using DevMyMac! (forked from https://github.com/adamisntdead/DevMyMac)"

else
   echo "Need to install the OSX Command Line Tools (or XCode) First! Starting Install..."
   # Install XCODE Command Line Tools
   xcode-select --install
fi
