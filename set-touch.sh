#!/bin/bash
# This script requires yad to be installed. If it is not installed, run:
# sudo apt install yad

# check for yad installation
monkg -l "yad"
if [ $? = '1' ]
then
   printf "Yad is not installed"
   sudo apt install yad
fi

# run xinput and find the search text for your touch screens, then set it below
screenSearch="Touch"
# run xrandr and find the search text for your monitors, then set it below
monintorSearch="DisplayPort-"

# dump xinput id's xrandr monitor searches into arrays
idArr=($(xinput | grep $screenSearch | awk '{gsub("id=",""); print $7}'))
monArr=($(xrandr | grep -E "$monintorSearch[0-9] connected" | awk -F '[-" "]' '{print $2}'))
cdate=($(date -I'seconds'))

# these are x and y coordinates to place pop-up alerts.
# adjust for your preference, screen resolution, and number of monitors.
# if fewer monitors are detected than are defined here, it's ok.
# to find your coordinates run the following from a terminal:
# yad --posx=<number> --posy=<number>
monx=(1620 2120 1620 2120)
mony=(880 880 1180 1180)

# loop through monitors. 
for mon in "${monArr[@]}"
do
   index=0
   declare -i mon
   # loop through touch screen id's
   for id in "${idArr[@]}"
   do
      declare -i id
      xinput map-to-output $id $monintorSearch$mon
      # pop up box at monx and mony coordinates. Tap OK, if it's registered on the wrong screen, it will prompt again.
      yad --posx=${monx[$mon]} --posy=${mony[$mon]} --close-on-unfocus --title="stuff" --text="Matching input: $id to Monitor: $mon."
      result=$?
      case $result in
         0)
            idArr=(${idArr[@]/$id})
            break
            ;;
         252)
            ((index=index+=1))
            ;;
         *)
            echo 'Unknown input' $result 
            ;;
      esac
   done
done
