This is an auto splitter for Lorn's Lure - (idk if it works on the itch.io version)

* https://store.steampowered.com/app/1417930/Lorns_Lure/ 
* https://rubeki.itch.io/lorns-lure

# **About:**

The project is designed to provide further segmentation for IL runs using checkpoints. The splits are set using variables from the active checkpoint, so hitting the intended checkpoint is important. The paths currently set for each level is based on (to the best of my ability) the current NG(NMG) WR path for that level. Checkpoints are chosen based on how likely they are to be hit (and at thematic intervals), but can be edited. 

Highly recommend using a visible checkpoint mod such as Speedrunner Helper to get used to seeing the active checkpoints
https://github.com/XdotCore/SpeedrunnerHelper

This repo contains Layout and Splits files mainly for convenience

# **How to use (if you've never used LiveSplit):** 
1. Clone the repo (or download as .zip), extract the folder to somewhere you'll remember it.
2. Open Livesplit
3. Right Click LiveSplit > Open Layout > From File... > your_location/ll.lsl
4. Right Click LiveSplit > Edit Layout > Layout Settings > Scriptable AutoSplitter > Choose file > your_location/LornsLure.ASL
5. if done correctly, settings/level selection menu opens - you can change to your prefered level here.
6. Right Click LiveSplit > Open Splits > From File... > your_location/ll splits/<the level you're running>
7. Open Lorn's Lure
8. notification
9. calibration


# **Calibration:**

This Autosplitter needs calibration to find the checkpoint values. <br/>
After the first notification, open Ch1, the wall, and runn the first 3 checkpoints until you get another notification.
If the notification doesn't appear after reaching the third checkpoint, hold T to restart and try again. <br/>
After the second notification, it's time to run :)

# **Gameplay:**
* timer resets on scene changes
* timer splits on active checkpoint changes, and end screen triggers
* if a listed checkpoint is missed, the subsequent splits will not trigger
* internal level selection settings take effect after resets (see first note)


if something is not working, enable logging and submit paste to issues



*i am not good at C#*
