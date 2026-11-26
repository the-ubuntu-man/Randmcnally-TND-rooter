#!/bin/bash
echo "Plug in your adb device then press any key to continue..."
read -rsn1

adb devices

echo "Please authorize your device if not already then press any key to continue..."
read -rsn1

echo "Rebooting to bootloader if you TND doesn't enter BL mode turn it off and power it on while holding volume down, then select fastboot/bootloader"
adb reboot bootloader

echo "For this step you will need physical access to the TND, IF IT ASKS YOU TO PRESS VOLUME UP TO UNLOCK IT PRESS VOLUME DOWN (there roles are switched)"
fastboot oem unlock
fastboot oem unlock_critical
fastboot flashing unlock
fastboot flashing unlock_critical

echo "Downloading mtkclient exploit"
git clone https://github.com/bkerler/mtkclient

echo "If you haven't setup the python3 venv yet set it up before coninuing (setup venv as mtkclient/venv)"
read -rsn1

fastboot reboot

mkdir backup 2>/dev/null
./mtkclient-executor.sh rl ./backup --skip userdata,navidata
./mtkclient-executor.sh reset

echo "Please unplug the usb cord and then turn the device on, once the device is on and unlocked continue (REMEBER TO RE-ENABLE ADB DEBUGGING)..."
read -rsn1

echo "Installing and launching magisk via ADB"
adb install assets/apps/magisk_26400.apk
echo "Sending boot.img"
adb push backup/boot.bin /sdcard/boot.img
echo "Done, now open magisk and patch the boot.bin. when done type the code after magisk_patched-26400_<code>.img. boot.bin is not on sdcard but infact on Internal Storage"
read -p "Code: " code

cd mtkclient
adb pull "/sdcard/Download/magisk_patched-26400_$code.img"

echo "Rebooting to bootloader if you TND doesn't enter BL mode turn it off and power it on while holding volume down, then select fastboot/bootloader"
adb reboot bootloader

fastboot flash boot "magisk_patched-26400_$code.img"
fastboot reboot

cd ..

echo "Rooted!"