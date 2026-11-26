#!/bin/bash

cd "$(dirname $0)"
if [[ "$(id -u)" -ne 0 ]]; then
  echo "You are not root!"
  exit 1
fi

dependencies=("adb" "fastboot" "git" "python3")

echo "checking dependencies..."
for dep in "${dependencies[@]}"; do
  if ! command -v "$dep" &>/dev/null; then
    echo "[$(date +"%I:%M %P")] Error: [$dep] is not installed"
    exit 1
  fi
done

while :; do 
  echo "---- TND ROOTER ----"
  echo "0: Quit"
  echo "1: Root System"
  echo "2: Debloat [ROOT]"
  echo "--------------------"
  echo ""
  read -rp "TND ROOTER % " opt

  if [ "$opt" -eq 0 ]; then
    break
  elif [ "$opt" -eq 1 ]; then
    ./assets/scripts/root.sh
  elif [ "$opt" -eq 2 ]; then
    ./assets/scripts/debloat.sh
  fi
done