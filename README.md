# set-touch
Bash script to help match multiple touch screens to the proper monitors.

 I regularly use Ubuntu with 2-4 identical touch screen monitors. The problem is, Ubuntu does not do a very good job of 
 matching the monitor to the USB port to which the touch elements are connected. Using xinput map-to-touch <id> <display>, 
 I can match these up, but there is no persistence for these settings. As a result, everytime I logout, lock, or reboot 
 my computer, the matchings are lost and I need to rematch everything.
  
 Using xinput, xrandr, grep, and awk, I managed to capture the information needed to match the display with the touch 
 element. Using yad, a pop-up alert is created on each screen with a confirmation dialoge. By clicking "Ok", the script 
 knows your touch screen is properly matched and it will move on to the next monitor. However, if you click cancel or the
 dialog box loses focus, but a touch is registered, then it assumes your touch element and the monitor are mismatched. 
 The next touch element ID will attempt to be matched to the same display and a new dialog box will appear. 

## First Use
 1. Run 'xinput' and determine which devices are your touch devices. Change the variable screenSearch to match the description
    of your device. You do not need to use the entire description, however the search string should be unique and match all of 
    your devices. 

 2. Run xrandr. This should list the available display ports on your system by port type. On my system, I only have 4 display 
    ports, so mine are listed as:
      DisplayPort-0 connected
      DisplayPort-1 connected
      etc
    So I modified my monitorSearch variable to be "DisplayPort-". Grep will use regex to match "monitorSearch[0-9] connected" 
    and dump the 0-9 into an array,    ensuring that the only monitors it will attempt to match are the connected ones.

 3. Run the script. On Debian based systems, the script will attempt to run detect yad and install it using apt if it is not 
    found. This can be modified to meet your operating system needs.

## To-Do
 1. If cancel is clicked, end the script.
 2. Get the current screen configuration (3x1, 2x2, 1x2, etc).
 3. Auto sense the resolution of the current monitor and find the center point of each monitor based on the screen configuration. 
 4. Modify monArr so it does not require monitorSearch to function.
