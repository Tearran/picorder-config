#!/bin/bash
clear

exit_message="System envoroment & requierments complete"
noact=" No actions requiered"
apt_picorder() {
    # Update Debian repository
    #sudo apt update
    [ ! -f "/usr/bin/git" ] && sudo apt install -y git cmake ;
    # Instal dev tools

    # Install Python Pip
    sudo apt install -y python3-pip python3-smbus sense-hat

    # Install other
    sudo apt install -y libmediainfo-dev libatlas-base-dev libopenjp2-7-dev libsdl2-dev libtiff5 libsdl-ttf2.0-dev  libsdl-gfx1.2-5 libsdl-image1.2 libsdl-kitchensink1 libsdl-mixer1.2 libsdl-sound1.2 libsdl-ttf2.0-0 libsdl1.2debian libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0

    echo "Requierments complete"
    echo " "
}

env_picorder() {
    # Setup Workenviroment if needed.
    # Check it directory exit otherwise create it
    sudo cp /boot/config.txt /boot/config.txt.back
    if [ ! -d "$HOME/.local/" ] ; then  mkdir "$HOME/.local/" ; else echo "$noact" ; fi
    if [ ! -d "$HOME/.local/bin/" ] ; then  mkdir "$HOME/.local/bin/" ; else echo "$noact" ; fi
    if [ ! -d "$HOME/.local/lib/" ] ;  then  mkdir "$HOME/.local/lib/" ; else echo "$noact" ; fi
    if [ ! -d "$HOME/.local/include/" ] ; then  mkdir "$HOME/.local/include/" ; else echo "$noact" ; fi

    echo "Workenviroment complete"
    echo " "
}

git_picorder() {
    # Checks is picorderOS directory exist esle downloads
    if [ ! -d "$HOME/.local/include/picorderOS" ] ; then

      cd "$HOME"/.local/include/ && git clone https://github.com/tearran/picorderOS.git
      #cd "$HOME/.local/include/picorderOS/" && python3 -m pip install -r requirements.txt

      echo "picorderOS donloaded "
      echo ""

    else

      echo "Please remove or rename your existing picorderOS install "
      exit
    fi
}

git_picorder_config(){
  if [ ! -d "$HOME/.local/include/picorder-config" ] ;
  then
    # clone picorder-config repository
    #cd "$HOME/.local/include/" && git clonhttps://github.com/directive0/picorderOS
    cd "$HOME/.local/include/" && git clone https://github.com/Tearran/picorder-config.git
    cd "$HOME/.local/include/picorder-config/" && chmod 755 "$HOME/.local/include/picorder-config/picorderOS"
    cd "$HOME/.local/include/picorder-config/" && chmod 755 "$HOME/.local/include/picorder-config/picorder-config"
  fi

    echo "picorder_config downloaded "
    echo " "
}

git_fbcp(){
if [ ! -d "$HOME/.local/include/fbcp-ili9341" ] ; then
  # clone fbcp repository
    cd "$HOME/.local/include/" && git clone https://github.com/Tearran/fbcp-ili9341.git
    cd "$HOME/.local/include/fbcp-ili9341" && mkdir build

fi
    echo ""
    echo "Display Drivers downloaded "
    echo ".. "
}

compile_st7735r(){
if [ -d "$HOME/.local/include/fbcp-ili9341" ] ; then

    #Compile Display drivers ST7735R
    cd "$HOME/.local/include/fbcp-ili9341/build/" && cmake -Wno-dev -DST7735R=ON -DGPIO_TFT_BACKLIGHT=18 -DGPIO_TFT_RESET_PIN=24 -DGPIO_TFT_DATA_CONTROL=23 -DSPI_BUS_CLOCK_DIVISOR=8 -DDISPLAY_SWAP_BGR=ON -DDISPLAY_INVERT_COLORS=ON ..
    cd "$HOME/.local/include/fbcp-ili9341/build/" && make -j
    sudo cp "/home/alpha/.local/include/fbcp-ili9341/build/fbcp-ili9341" "/usr/bin/fbcp"
    echo ""
    echo "Display Drivers Compiled: "
    echo "          For the ST7735R "
    echo  "/home/alpha/.local/include/fbcp-ili9341/build/fbcp-ili9341"
    # add fbcp to run durring bootup
    sudo sed -i -e 's/exit 0/fbcp&/g' /etc/rc.local
    sudo sed  -n 'exit 0' /etc/rc.local


#TODO
# Configuring display size will effect both HDMI and TFT
# Following append to /boot/config.txt

#disable_overscan=1'
#hdmi_group=2'
#hdmi_mode=87'
#hdmi_cvt=160 128 60 1 0 0 0'
#hdmi_force_hotplug=1'

## Recover screen space. hideing the raspberry
sudo sed -i -e 's/rootwait/logo.nologo rootwait/g'  /boot/cmdline.txt
fi
    echo ""
    echo "Display Drivers donloaded "
    echo ".. "
}
# TODO interactive setting picorder.ini
#replace this with that
#sed 's/^avalue=.*/replace=ivalue/g' test.txt

env_picorder
#apt_picorder
git_picorder
git_picorder_config
git_fbcp
compile_st7735r
echo "$exit_message"
