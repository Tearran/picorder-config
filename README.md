# picorder-config

picorder-config is a set shell commands that aim to install, configure and, add customization to [piCorderOS](https://github.com/directive0/picorderOS)

# instalation:
Curl 
```bash 
curl https://raw.githubusercontent.com/Tearran/picorder-config/master/picorder_setup.sh | bash
 
``` 
wget
```sh 
wget https://raw.githubusercontent.com/Tearran/picorder-config/master/picorder_setup.sh
chmod +x picorder-setup
sh ./picorder-setup
```
# Features

- Enable i2c
- Enable spi
- Add Userspace "$HOME/.local/bin" to path 
- Download and install picorderOs source
- Install requiered system libraries
- Install requiered python libraries
- Install piCoerderOS System launcher "$HOME/.local/bin/piCoerderOS"
- Install picoerder-config System launcher
  - Menu base
  - todo: setting "$HOME/.local/include/picorderOS/picorder.ini"
  - todo: setting "/boot/config.txt"
