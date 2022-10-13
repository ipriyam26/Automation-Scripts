#!/bin/bash
while getopts 'v:b:' OPTION; do
  case "$OPTION" in
    v)
      volume="$OPTARG"
      ;;
    b)
      brightness="$OPTARG"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-l] [-h] [-a somevalue]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
sudo osascript -e "set Volume $volume"
currentBrightness=$(/usr/libexec/corebrightnessdiag status-info | grep 'DisplayServicesBrightness ' |grep -o  "[\.0-9]*")
NUM="0.0625"
currentB=$(awk '{print $2/$1}' <<<"${NUM} ${currentBrightness}")
currentB=${currentB%%.*}
diff=$((brightness-currentB))
if [[ $diff -lt 0 ]];
then

  while [ $diff -lt 0 ]
  do
    sudo osascript -e 'tell application "System Events"' -e 'key code 145' -e ' end tell'
    diff=$(( $diff + 1 ))
  done
else
  while [ $diff -gt 0 ]
  do
    sudo osascript -e 'tell application "System Events"' -e 'key code 144' -e ' end tell'
    diff=$(( $diff - 1 ))
  done
fi
