#! /usr/bin/bash -e -o pipefail

# run from home dir
#Set pwd as $HOME
cd $HOME

if [ -f /etc/os-release ]; then
	OS=$NAME
fi
# installing all the packages
if [ $NAME="Ubuntu" ]; then
	INSTALLER="apt"
	sudo apt update && sudo apt-get upgrade
fi
#---------------------- PACKAGES ----------------------
sudo $INSTALLER install tmux -y
sudo $INSTALLER install fish -y
sudo $INSTALLER install curl -y
sudo $INSTALLER install wget -y
sudo $INSTALLER install unzip -y
sudo $INSTALLER install tar -y
sudo $INSTALLER install gzip -y
sudo $INSTALLER install tree -y
sudo $INSTALLER install btop -y

sudo $INSTALLER install git -y
sudp $INSTALLER install googler -y
sudo $INSTALLER install build-essential -y
sudo $INSTALLER install gdb -y
sudo $INSTALLER install npm -y
sudo $INSTALLER install ripgrep -y
sudo $INSTALLER install direnv -y
sudo $INSTALLER install bat -y
sudo $INSTALLER install tig -y

#---------------------- CMAKE ----------------------
wget https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2-linux-x86_64.sh
sudo sh cmake-3.30.2-linux-x86_64.sh --prefix=/usr/local --skip-license

#---------------------- Neovim ----------------------
# Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage &&
	chmod u+x nvim.appimage &&
	sudo mkdir -p /opt/nvim &&
	sudo mv nvim.appimage /opt/nvim/nvim &&
	# nvim requires FUSE
	sudo add-apt-repository universe && sudo apt install libfuse2 -y

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \ 
     &&  sudo apt install ./google-chrome-stable_current_amd64.deb -y \ 
     && rm google-chrome-stable_current_amd64.deb

# cleanup
sudo apt autoremove

#------------------GIT AND GITHUB---------------------

# github cli gh
sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
	sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt install gh -y

# github auth for git
ssh-keygen -t ed25519 -a 100 -f $HOME/.ssh/github
echo "====Need to setup gh login only once!====="
gh auth login
gh auth setup-git


#---------------------- DOT FILES ----------------------
echo ".cfg" >.gitignore
# remove the existing .cfg folder
rm -rf $HOME/.cfg && \
git clone --bare https://github.com/linem-davton/.cfg $HOME/.cfg

# backup the dotfiles that already exit
mkdir -p $HOME/.config-backup/.config/fish &&
	git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} |
	xargs -I{} mv {} .config-backup/{}

# checkout the dotfiles
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no

#---------------------- OBSIDIAN----------------------
# setup obsidian
sudo snap install --classic obsidian
git clone https://github.com/linem-davton/obsidianvault.git $HOME/obsidian
sudo apt-get install "fonts-cmu"


#---------------------- FZF ----------------------
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#---------------------- zoxide  ----------------------
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh


#---------------------- lazydocker----------------------
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

#---------------------- lazygit----------------------
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
