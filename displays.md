# WaveShare 1.3inch display HAT
## ST7789 240x240 pixel LCD display, three buttons and joy.
Introduction
This is an IPS LCD display HAT for Raspberry Pi, 1.3inch diagonal, 240x240 pixels, with embedded controller, communicating via SPI interface.

More
Specification
Operating voltage: 3.3V/5V
Interface: SPI
LCD type: IPS
Controller: ST7789VM
Resolution: 240(H)RGB x 240(V)
Display size: 23.4（H）x 23.4（V）mm
Pixel size: 0.0975（H）x 0.0975（V）mm
Dimension: 65 x 30.2(mm)


Pinout
- PIN	Raspberry Pi Interface (BCM)	Description
- KEY1	P21	KEY1GPIO
- KEY2	P20	KEY2GPIO
- KEY3	P16	KEY3GPIO
- Joystick UP	P6	Upward direction of the Joystick
- Joystick Down	P19	Downward direction of the Joystick
- Joystick Left	P5	Left direction of the Joystick
- Joystick Right	P26	Right direction of the Joystick
- Joystick Press	P13	Press the Joystick
- SCLK	P11/SCLK	SPI clock line
- MOSI	P10/MOS	SPI data line
- CS	P8/CE0	Chip selection
- DC	P25	Data/Command control
- RST	P27	Reset
- BL	P24	Backlight


# Pimoroni Pirate Audio 
ST7789 240x240 pixel LCD display, four buttons and some form of audio output.

## Hardware

* st7789 display - https://github.com/pimoroni/st7789-python
* four buttons, active low connected to BCM 5, 6, 16, and 24 (A, B, X, Y respectively)

## Installation

Add  lines to `/boot/config.txt` to enable audio:

```
dtoverlay=hifiberry-dac
gpio=25=op,dh
```

Disabling onboard audio to reduce audio device prompt time:

```
dtparam=audio=off
```

## dependencies:

```
sudo apt-get update
sudo apt-get install python-rpi.gpio python-spidev python-pip python-pil python-numpy
```

st7789 library:

```
sudo pip install st7789
```

example from: https://github.com/pimoroni/st7789-python/tree/master/examples
