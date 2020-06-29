#!/bin/bash

packages="i3-gaps
i3lock-color
rxvt-unicode
dunst
light
alsa-utils
dzen2
rofi
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
gvfs-afc
gvfs-gphoto2
gvfs-smb
udiskie
dconf-editor
exfat-utils
polybar
stow
nitrogen
oh-my-zsh-git
terminator
zsh-autosuggestions
"

stowlist="i3
polybar
rofi
scripts
wal
udiskie
terminator
nautilus-extensions
vim
zsh
picom
"

check_requirements() {
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
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -rsci --noconfirm
		cd ..
		rm -r yay
		yay -Sy
	fi

}

check_conflicts() {
	if [[ -d ~/.config/i3 ]]
	then
		mv ~/.config/i3 ~/.config/i3.bck
	fi

	if [[ -d ~/.i3 ]]
	then
		mv ~/.i3 ~/.i3.bck
	fi

	if [[ -d ~/.config/dunst ]]
	then
		mv ~/.config/dunst ~/.config/dunst.bck
	fi

	if [[ -f ~/.vimrc ]]
	then
		mv ~/.vimrc ~/.vimrc.bck
	fi

	if [[ -f ~/.zshrc ]]
	then
		mv ~/.zshrc ~/.zshrc.bck
	fi

	if [[ -f ~/.config/compton.conf ]]
	then
		mv ~/.config/compton.conf ~/.config/compton.conf.bck
	fi

	if [[ -d ~/.config/compton ]]
	then
		mv ~/.config/compton ~/.config/compton.bck
	fi

}

install_packages() {
	yay -Sy
	printf "\n -> installing(via yay): $(echo $1 | sed 's/\n/, /g'), custom-fonts\n"
	yay -S ${packages}  --needed --answerclean All --answerdiff None --removemake

	dir=$(pwd)
	cd res/packages/custom-fonts
	makepkg -rsci --noconfirm
	cd ${dir}
}

install_dotfiles() {
	printf "\n -> installing dotfiles"
	dir=$(pwd)

	stow -t ~ ${stowlist}
	
	mkdir ~/.config/dunst
	ln -sf ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc

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
install_packages
install_dotfiles
post_install

