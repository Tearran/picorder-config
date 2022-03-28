#!/usr/bin/bash
clear
TERM=ansi
{
theme="dark:0" # Theme setting dark comment to enable system colors

if [ $theme = "dark:0" ]; then
  export NEWT_COLORS='
    root=white,black
    window=white,black
    textbox=white,black
    title=white,black
    listbox=white,black
    sellistbox=black,yellow
    actsellistbox=black,yellow
    border=blue,black
    actbutton=black,green
    '
fi
}

tput cup 0 100  |  whiptail --infobox "Setting things up...." 20 66;
rm -f "$HOME/.bash_logout" # For development; Save the bash history for referance.
whiptail --infobox "Setting Boot to CLI...." 10 100
tput cup 0 100  |  whiptail --infobox "Setting Boot to cli...." 20 66;
#sudo raspi-config nonint do_boot_behaviour B2 # Change to cli auto login
sudo raspi-config nonint do_i2c 1 #enable i2c

# rm -r Bookshelf/ Desktop/ Documents/ Music/ Pictures/ Public/ Templates/ Videos/ Downloads/

tput cup 0 100  |  whiptail --infobox "Update system repository...." 20 66;
sudo apt update
tput cup 0 100  |  whiptail --infobox "Download source code...." 20 66;
sudo apt install -y git cmake python3-pip

echo "........................................."
echo " apt requierments complete" |  whiptail --infobox "apt requierments complete...." 20 66;
echo "........................................."

[ -d "$HOME/.local/" ] ||  mkdir "$HOME/.local/"
[ -d "$HOME/.local/bin/" ] ||  mkdir "$HOME/.local/bin/"
[ -d "$HOME/.local/lib/" ] || mkdir "$HOME/.local/lib/"
[ -d "$HOME/.local/include/" ] ||  mkdir "$HOME/.local/include/"

echo "........................................."
echo " system envoroment complete "  |  whiptail --infobox "system envoroment complete...." 20 66;
echo "........................................."

[ ! -d "$HOME/.local/include/picorder-config" ] && cd "$HOME/.local/include/" && git clone https://github.com/Tearran/picorder-config.git
sudo cp /usr/share/plymouth/themes/pix/splash.png /usr/share/plymouth/themes/pix/splash.png.back
sudo cp "$HOME/.local/include/picorder-config/include/splash.png" /usr/share/plymouth/themes/pix/splash.png
sudo cp "$HOME/.local/include/picorder-config/include/config.txt" /boot/config.txt  || echo "error Display /boot/config.txt"
cp "$HOME/.local/include/picorder-config/include/picorder.ini" "$HOME/.local/include/picorderOS/"

echo "........................................."
echo " picorder-config source Downloaded "  |  whiptail --infobox "picorder-config source Downloaded...." 20 66;
echo "........................................."

[ ! -d "$HOME/.local/include/picorderOS" ] && cd "$HOME"/.local/include/ && git clone https://github.com/directive0/picorderOS.git
cp "$HOME/.local/include/picorder-config/picorder.ini" "$HOME/.local/include/picorderOS/picorder.ini"

echo "........................................."
echo " picorderOS source Downloaded "       |  whiptail --infobox "picorderOS source Downloaded...." 20 66;
echo "........................................."

[ ! -d "$HOME/.local/include/fbcp-ili9341" ] && cd "$HOME/.local/include/" && git clone https://github.com/juj/fbcp-ili9341
#[ ! -d "$HOME/.local/include/fbcp-ili9341" ] && cd "$HOME/.local/include/" && git clone https://github.com/Tearran/fbcp-ili9341.git
[ -d "$HOME/.local/include/fbcp-ili9341/build" ] || cd "$HOME/.local/include/fbcp-ili9341" && mkdir build

echo "........................................."
echo " Framebuffer Copy source Downloaded"   |  whiptail --infobox "Framebuffer Copy source Downloaded...." 20 66;
echo "........................................."

tput cup 0 100  |  whiptail --infobox "Setting Display up...." 20 66;
[ -d "$HOME/.local/include/fbcp-ili9341/build/" ] && cd "$HOME/.local/include/fbcp-ili9341/build/" || exit 1
[ -d "$HOME/.local/include/fbcp-ili9341/build/" ] && cmake -Wno-dev -DST7735R=ON -DGPIO_TFT_BACKLIGHT=18 -DGPIO_TFT_RESET_PIN=24 -DGPIO_TFT_DATA_CONTROL=23 -DSPI_BUS_CLOCK_DIVISOR=8 -DSTATISTICS=0 -DDISPLAY_SWAP_BGR=ON -DDISPLAY_INVERT_COLORS=OFF ..
[ -d "$HOME/.local/include/fbcp-ili9341/build/" ] && cd "$HOME/.local/include/fbcp-ili9341/build/" && make -j
[ ! -f "/usr/bin/fbcp"  ] &&  sudo cp "$HOME/.local/include/fbcp-ili9341/build/fbcp-ili9341" "/usr/bin/fbcp"
#sudo cp "$HOME/.local/include/picorder-config/include/fbcpd.service" /etc/systemd/system/fbcpd.service ;
#sudo systemctl enable fbcpd ;
#sudo systemctl stop fbcpd ; tput cup 0 100
#sudo systemctl start fbcpd ; tput cup 0 100  |  whiptail --infobox "Display server set...." 20 66;

{
cd "$HOME/.local/include/picorder-config/" || exit 0

cat << OSEOF > picorderosd.service
[Unit]
Description=Starts picorderOS
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 main.py
WorkingDirectory=$HOME/.local/include/picorderOS/
StandardInput=tty-force

[Install]
WantedBy=multi-user.target
OSEOF

[ -f /etc/systemd/system/picorderosd.service ] && sudo systemctl disable picorderosd ;
sudo mv "$HOME/.local/include/picorder-config/picorderosd.service" /etc/systemd/system/
sudo systemctl enable picorderosd |  whiptail --infobox "Enable picorderosd service...." 20 66;
}

# sudo apt purge python3-cap1xxx python3-envirophat python3-pillow python3-pygame python3-numpy python3-psutil
sudo apt install -y libmediainfo-dev libatlas-base-dev libopenjp2-7-dev libsdl2-dev libtiff5 libsdl-ttf2.0-dev  libsdl-gfx1.2-5 libsdl-image1.2 libsdl-kitchensink1 libsdl-mixer1.2 libsdl-sound1.2 libsdl-ttf2.0-0 libsdl1.2debian libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0
cd "$HOME"/.local/include/picorderOS && sudo /usr/bin/python3 -m pip install -r requirements.txt
sudo systemctl start picorderosd |  whiptail --infobox "Starting picorderosd service...." 20 66;
if whiptail --yesno "Instaltion complete! Reboot?" 10 100 --defaultno; then echo "Yes! Rebooting"; sudo reboot; else echo "No !"; exit 0; fi
