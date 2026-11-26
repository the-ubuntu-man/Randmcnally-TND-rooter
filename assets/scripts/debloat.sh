#!/bin/bash

androidsu="adb shell su -c"

echo -en "\x1b[1;31mWARNING:\x1b[0m this permenently modifies /system and can only be undone via reflashing system.bin\ncontinue? [Y/n] "
read -rn1 continue

if [[ "${continue,,}" != "y" ]]; then
  echo "Debloat Aborted"
  exit 1
fi

read -rsn1 -p "Connect your device via adb then press any key to continue."

echo "remounting partitions"
$androidsu "mount -o remount,rw /"
$androidsu "mount -o remount,rw /system"
$androidsu "mount -o remount,rw /vendor"
echo "Done!"

echo "installing com.android.launcher3 to priv-app"
adb push "$(dirname $0)/../apps/launcher3.apk" /sdcard/Launcher3.apk
$androidsu "mkdir /system/priv-app/Launcher3"
$androidsu "mv /sdcard/Launcher3.apk /system/priv-app/Launcher3/"
$androidsu "chown -R 0:0 /dev/priv-app/Launcher3"
$androidsu "chmod 755 /dev/priv-app/Launcher3; chmod 644 /dev/priv-app/Launcher3/Launcher3.apk"
echo "Done!"

echo "deleting /system/priv-app bloatware"
$androidsu "cd /system/priv-app; rm -rf rm_*" # rm_* -> rm_ is at the beggining of every randmcnally priv-app app
$androidsu "rm /vendor/app/rm_VehicleLink"    # deletes the extra bloatware app
echo "Done"

echo "Debloat Finished, remounting partitions"
$androidsu "mount -o remount,ro /"
$androidsu "mount -o remount,ro /system"
$androidsu "mount -o remount,ro /vendor"
echo "Finished!"