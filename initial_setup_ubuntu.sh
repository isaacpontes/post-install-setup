#!/bin/bash

# Uncomment if you want the execution to stop in case of error
# Descomente se desejar que a execução pare em caso de erro
# set -e

# ---- LANGUAGE VERSIONS / VERSÕES DAS LINGUAGENS ---- #
NODEJS_VERSION="18.14.2"
RUBY_VERSION="3.2.1"

# ---- URLS ---- #
# URL_VSCODE="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
URL_MESLO_FONT="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip"

# ---- PATHS / CAMINHOS ---- #
DOWNLOADS_DIR="$HOME/initial-setup-downloads"
FONTS_PATH="$HOME/.local/share/fonts"

# ---- COLORS / CORES ---- #
RED="\e[1;91m"
GREEN="\e[1;92m"
NO_COLOR="\e[0m"

# ---- PACKAGES TO INSTALL / PACOTES A ISNTALAR ---- #
APT_PACKAGES=(
  snapd
  curl
  git
  wget
  ares
  ffmpeg
  obs-studio
  mysql-server
  openssl
  php
  php-common
  php-bcmath
  php-curl
  php-json
  php-mbstring
  php-mysql
  php-tokenizer
  php-xml
  php-zip
)
SNAP_PACKAGES=(
  chromium
  discord
  postman
)

# ---- FUNCTIONS ---- #
system_upgrade() {
  sudo apt update && sudo apt dist-upgrade -y
}

apt_update() {
  sudo apt update -y
}

remove_apt_locks() {
  sudo rm -f /var/lib/dpkg/lock-frontend
  sudo rm -f /var/cache/apt/archives/lock
}

test_internet_connection() {
  if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    echo -e "${RED}[ERROR] - Seu computador precisa estar conectado à internet.${NO_COLOR}"
    exit 1
  else
    echo -e "${GREEN}[INFO] - Teste de conexão realizado com sucesso.${NO_COLOR}"
  fi
}

install_debs() {
  echo -e "${GREEN}[INFO] - Instalando pacotes .deb${NO_COLOR}"

  sudo add-apt-repository -y ppa:obsproject/obs-studio

  for package_name in ${APT_PACKAGES[@]}; do
    sudo apt install "$package_name" -y
    echo "----------\n[DONE] - $package_name\n----------"
  done
}

install_snaps(){
  echo -e "${GREEN}[INFO] - Instalando SNAPs${NO_COLOR}"
  sudo snap install code --classic
  echo "----------\n[DONE] - code\n----------"
  for package_name in ${SNAP_PACKAGES[@]}; do
    sudo snap install "$package_name"
    echo "----------\n[DONE] - $package_name\n----------"
  done
}

install_asdf_and_languages() {
  echo -e "${GREEN}[INFO] - Instalando asdf-vm, Node.js e Ruby${NO_COLOR}"
  if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc
    echo ". $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
    echo "----------\n[DONE] - asdf-vm\n----------"
  fi
  source ~/.bashrc
  eval "$(cat ~/.bashrc | tail -n +10)"
  # Node.js
  sudo apt install dirmngr gpg gawk
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs "$NODEJS_VERSION"
  asdf global nodejs "$NODEJS_VERSION"
  # Ruby
  sudo apt install -y autoconf bison patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby "$RUBY_VERSION"
  asdf global ruby "$RUBY_VERSION"
}

install_zsh() {
  echo -e "${GREEN}[INFO] - Installing zsh${NO_COLOR}"
  sudo apt install zsh -y
  zsh
  sudo chsh -s $(which zsh)
}

install_meslo_nerd_font() {
  wget -c "$URL_MESLO_FONT" -P "$DOWNLOADS_DIR"
  mkdir -p "$FONTS_PATH"
  unzip $DOWNLOADS_DIR/Meslo.zip -d "$FONTS_PATH"
  rm -rf $DOWNLOADS_DIR/
  fc-cache -fv
}

install_ohmyzsh() {
  echo -e "${GREEN}[INFO] - Installing oh-my-zsh${NO_COLOR}"
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  # syntax-highlight plugin
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  fi
  # autosuggestions plugin
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  fi
  # k plugin
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/k" ]; then
    git clone https://github.com/supercrabtree/k $HOME/.oh-my-zsh/custom/plugins/k
  fi
  # Add the plugins
  sed -i 's/^plugins=.*/plugins=( asdf git zsh-autosuggestions zsh-syntax-highlighting k )/' ~/.zshrc
  # powerlevel10k theme
  if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
  fi
  # Use powerlevel10k
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
}

system_cleanup() {
  system_upgrade -y
  sudo apt autoclean -y
  sudo apt autoremove -y
}

# ---- EXECUTE ---- #

test_internet_connection
remove_apt_locks
system_upgrade
remove_apt_locks
install_debs
install_snaps
remove_apt_locks
apt_update
install_asdf_and_languages
remove_apt_locks
apt_update
install_zsh
install_meslo_nerd_font
install_ohmyzsh
system_upgrade
system_cleanup

# ---- FINISH ---- #
echo -e "${GREEN}[INFO] - Instalações concluídas. Reiniciando o sistema...${NO_COLOR}"

# Uncomment if you want to restart the system automatically when finishing the script
# Descomente se desejar reiniciar o sistema automaticamente ao finalizar o script
# shutdown -r now
