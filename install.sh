#!/bin/bash

backup_location=./backups

# for light to work user has to be in video group
packages="i3-gaps
i3lock-color
rxvt-unicode
dunst
light
alsa-utils
rofi
rofi-calc
scrot
jsoncpp
python-pywal
picom
lxappearance
acpi
pulseaudio
pulseaudio-alsa
pavucontrol
papirus-icon-theme
nautilus
libnautilus-extension
python-nautilus
gvfs-afc
gvfs-gphoto2
gvfs-smb
udiskie
dconf-editor
exfat-utils
polybar
stow
nitrogen
starship
alacritty
tmux
zsh-autosuggestions
gtk-engine-murrine
ttf-cascadia-code
bat
exa
"

stowlist="i3
polybar
rofi
scripts
wal
udiskie
alacritty
nautilus-extensions
vim
zsh
picom
dunst
starship
"

move_dir() {
	if [[ ! -d $2 ]]
	then
		mkdir -p $2
	fi

	mv $1 $2
}

check_requirements() {
	sudo pacman -Sy
	pacman -Q git &> /dev/null
	if [[ "$?" -ne 0 ]]
	then
		echo -e " -> installing: git\n"
		sudo pacman -S git --noconfirm
	fi

	pacman -Q yay &> /dev/null
	if [[ "$?" -ne 0 ]]
	then
		echo -e "-> installing: yay\n"
		sudo pacman -S base-devel --noconfirm
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -rsci --noconfirm
		cd ..
		sudo rm -r yay
		yay -Sy
	fi

}

check_conflicts() {
	if [[ ! -d $backup_location ]]
	then
		mkdir $backup_location
	fi
	if [[ -d ~/.config/i3 ]]
	then
		move_dir ~/.config/i3 ${backup_location}/.config/i3
	fi

	if [[ -d ~/.i3 ]]
	then
		move_dir ~/.i3 ${backup_location}/.i3
	fi

	if [[ -d ~/.config/dunst ]]
	then
		move_dir ~/.config/dunst ${backup_location}/.config/dunst
	fi

	if [[ -f ~/.vimrc ]]
	then
		mv ~/.vimrc ${backup_location}/.vimrc
	fi

	if [[ -f ~/.zshrc ]]
	then
		mv ~/.zshrc ${backup_location}/.zshrc
	fi

	if [[ -f ~/.config/compton.conf ]]
	then
		mkdir -p ${backup_location}/.config
		mv ~/.config/compton.conf ${backup_location}/.config/compton.conf
	fi

	if [[ -d ~/.config/compton ]]
	then
		move_dir ~/.config/compton ${backup_location}/.config/compton
	fi

}

install_packages() {
	yay -Sy
	printf "\n -> installing(via yay): $(echo $1) custom-fonts\n\n"
	yay -S $1  --needed --answerclean All --answerdiff None --removemake

	dir=$(pwd)
	cd res/packages/custom-fonts
	makepkg -rsci --noconfirm
	cd ${dir}
}

install_dotfiles() {
	printf "\n -> installing dotfiles"
	dir=$(pwd)
	stow -t ~ ${stowlist}
	
	echo "VteTerminal,
TerminalScreen,
vte-terminal {
    padding: 10px 10px 10px 10px;
    -VteTerminal-inner-border: 10px 10px 10px 10px;
}" >> ~/.config/gtk-3.0/gtk.css


	printf "\n -> copying backgrounds"
	if [[ ! -d ~/Pictures/Wallpapers ]]
	then
		mkdir -p ~/Pictures/Wallpapers
	fi
	cp res/wallpapers/* ~/Pictures/Wallpapers

	printf "\n -> copying zsh theme\n"
	sudo cp res/zsh-themes/zero.zsh-theme /usr/share/oh-my-zsh/themes

	cd ${dir}
}

post_install() {
	printf "\n -> changing default shell to zsh\n"
	chsh -s /usr/bin/zsh
	
	printf "\n -> setting wallpaper\n"
	~/.scripts/change-bg ~/Pictures/Wallpapers/forest.jpg

	printf "\n Please log out for all the changes to take effect.\n"
}

check_requirements
check_conflicts
install_packages "$packages"
install_dotfiles
post_install

