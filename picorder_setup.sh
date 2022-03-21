#!/bin/bash
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
    button=white,black
    '
fi
}
#TODO
# Configuring display size will affect both HDMI and TFT
# Following append to /boot/config.txt
#disable_overscan=1
#hdmi_group=2
#hdmi_mode=87
#hdmi_cvt=160 128 60 1 0 0 0
#hdmi_force_hotplug=1
#!/usr/bin/bash
rm -f /home/alpha/.bash_logout # For development; Save the bash history for referance.
sudo raspi-config nonint do_boot_behaviour B2 # Change to cli auto login
sudo raspi-config nonint do_i2c 1 #enable i2c
#sudo sed -i -e 's/rootwait/logo.nologo rootwait/g'   /boot/config.txt || echo "error config"
# uncomment to Unclutter home removing unused folders 
# rm -r Bookshelf/ Desktop/ Documents/ Music/ Pictures/ Public/ Templates/ Videos/ Downloads/
sudo apt update
sudo apt install -y git 
echo "........................................."
echo " apt requierments complete"
echo "........................................."
[ -d "$HOME/.local/" ] ||  mkdir "$HOME/.local/"
[ -d "$HOME/.local/bin/" ] ||  mkdir "$HOME/.local/bin/"
[ -d "$HOME/.local/lib/" ] || mkdir "$HOME/.local/lib/"
[ -d "$HOME/.local/include/" ] ||  mkdir "$HOME/.local/include/"
echo "........................................."
echo " system envoroment complete"
echo "........................................."
[ ! -d "$HOME/.local/include/picorder-config" ] && cd "$HOME/.local/include/" && git clone https://github.com/Tearran/picorder-config.git
sudo cp /usr/share/plymouth/themes/pix/splash.png /usr/share/plymouth/themes/pix/splash.png.back
sudo cp "$HOME/.local/include/picorder-config/include/splash.png" /usr/share/plymouth/themes/pix/splash.png
echo "........................................."
echo " picorder-config source Downloaded"
echo "........................................."
[ ! -d "$HOME/.local/include/picorderOS" ] && cd "$HOME"/.local/include/ && git clone https://github.com/directive0/picorderOS.git
sudo apt install -y python3-pip python3-smbus sense-hat
echo "........................................."
echo " picorderOS source Downloaded"
echo "........................................."
[ ! -d "$HOME/.local/include/fbcp-ili9341" ] && cd "$HOME/.local/include/" && git clone https://github.com/Tearran/fbcp-ili9341.git
[ -d "$HOME/.local/include/fbcp-ili9341/build" ] || cd "$HOME/.local/include/fbcp-ili9341" && mkdir build
echo "........................................."
echo " Framebuffer Copy source Downloaded"
echo "........................................."
sudo apt install -y cmake
[ -d "$HOME/.local/include/fbcp-ili9341/build/" ] && cd "$HOME/.local/include/fbcp-ili9341/build/" || exit 1
[ -d "$HOME/.local/include/fbcp-ili9341/build/" ] && cmake -Wno-dev -DST7735R=ON -DGPIO_TFT_BACKLIGHT=18 -DGPIO_TFT_RESET_PIN=24 -DGPIO_TFT_DATA_CONTROL=23 -DSPI_BUS_CLOCK_DIVISOR=8 -DSTATISTICS=0 -DDISPLAY_SWAP_BGR=ON -DDISPLAY_INVERT_COLORS=OFF ..
[ -d "$HOME/.local/include/fbcp-ili9341/build/" ] && cd "$HOME/.local/include/fbcp-ili9341/build/" && make -j
[ ! -f "/usr/bin/fbcp"  ] &&  sudo cp "/home/alpha/.local/include/fbcp-ili9341/build/fbcp-ili9341" "/usr/bin/fbcp"
sudo cp "$HOME/.local/include/picorder-config/include/fbcpd.service" /etc/systemd/system/fbcpd.service ; 
sudo systemctl enable fbcpd ;
sudo systemctl start fbcpd ;

#sudo apt install -y libmediainfo-dev libatlas-base-dev libopenjp2-7-dev libsdl2-dev libtiff5 libsdl-ttf2.0-dev  libsdl-gfx1.2-5 libsdl-image1.2 libsdl-kitchensink1 libsdl-mixer1.2 libsdl-sound1.2 libsdl-ttf2.0-0 libsdl1.2debian libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0
