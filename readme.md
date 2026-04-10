
# Minimalistic Conky Theme

This is a minimalistic-ish theme for Conky.<br>
While browsing different websites for inspiration i came across a minimalist Theme and decided to adapt the style.<br>
<br>

## Screenshots
For the sake of "anomyity" i blacked out a few things. <br>
<img align="left" src="/conky-screenshot.png">

## Thing to manually do:
### For all .conf:<br>
- The scripts were made with a 1366 x 768 Resolution in mind<br><br>
### For minimal_top.conf<br>
- The config uses RythmBox as a mediaplayer information source. If you use other media players it wont work unless you update the script by yourself.<br><br>
### For minimal_left.conf<br>
- Due to different Linux Versions using diffferent network interface names: change "wlan0" to your active interface name.<br><br>
### For minimal_right.conf<br>
- change the "wttr.in/Berlin" part in minimal_right.conf to whatever city ou live in.<br>
- if you use debian/ubuntu based Linux Version: change "execi 3600 pacman -Q | wc -l" to "apt list --installed | wc -l" <br>
- "execi 3600 cat /proc/cpuinfo | grep -i 'Model name' -m 1 | cut -c14-18,22-29,38-43" is cut to my liking. you might want to either remove the cutting or modify it.<br>
- "${fs_used /}", "${fs_size /}" and ${fs_bar 11,170 /} show the root drive. for other drives replace the "/" with the mounting point of your additional drives (ie: /mnt/media)<br><br>
<br>
<br>
i sadly forgot where i saw the original so i can neither attribute them nor give them credit. So if your the one who made the original: credits and kudos to ya!<br>

## Authors

- [@PixelJaeger](https://www.github.com/PixelJaeger)
