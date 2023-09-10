# DHSim
H-Shifter simulator for XInput gamepads

## Environment
Tested on
- Windows 11 Pro 22H2
- DualShock 3 (DsHidMini v2.2.282)
- AutoHotKey v1.1.37.01
- Euro Truck Simulator 2 v1.48

## Usage
- Setup
    1. Run DHSim and an game you want to setup.
    2. Open the game button configuration.
    3. Click the `Setup` button in DHSim.
    4. When DHSim says `Pos <Gear>: Waiting...`, click the corresponding button setting in the game within 5 seconds and wait for input.
        - If 5 seconds are not enough, you can change the waiting time in the settings.
    5. Do this for all buttons and done.

- Use
    1. Press the DPad Up/Down, the shift position will be raised/lowered.
    2. Press the left thumb, the shift position will be reset to N.
        - You can change buttons in the settings.

## Settings
The settings can be found in line 15- of DHSim.ahk.
- Buttons
    You can change the gamepad buttons. Button names is found in line 34- of XInput.ahk

## Credits
DHSim use the following libraries.
- [AHK-CvJoyInterface](https://github.com/evilC/AHK-CvJoyInterface) by [evilC](https://github.com/evilC)
- [XInput.ahk](https://www.autohotkey.com/boards/viewtopic.php?t=29659) by Lexikos
