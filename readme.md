<img align="left" src="/conky_preview.jpg">

Original Theme by "wekers" -> https://github.com/wekers/conky<br>
<br>
Now in new LUA-Like config script and with working LUA-scripts!<br>
It _(!)should(!)_ work by just typing "conky -c /path/to/this/file"<br>
<br>
- You need to change "lua_load = '~/.conky/pixel_new/drives.lua'," in<br>
the .conf file to the path of where you put your drives.lua!<br>
- Remeber to change "wlp2s0" or "eno1" to YOUR Network-Interface<br>
- depending on the amount of drives you actively use the sda list<br>
- will expand, but partitions like efi and swap will be filtered out<br>
<br>
all credits go to wekers<br>
<br>
Notes:<br>
1. The whole theme was originally made for my Laptop with a weird resolution of 1336 by 768. <br>
So if you use it on anything "better" it's gonna be small. <br>
Workaround: use bigger text and/or add spaces between the categories. <br>
2. For security reasons i blacked out parts of my WAN-IP and IPV6. It works nonetheless. <br>
