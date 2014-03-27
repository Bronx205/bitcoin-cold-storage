#! /bin/bash
find /home/pi/coldstorage/files -iname "*.*" -exec rm {} \;
find /media/coldstorage/ -type f -exec rm {} \;
find /media/coldstorage/ -mindepth 1 -depth -type d -exec rmdir {} \;
find /media/uploads/ -type f -exec rm {} \;
find /media/uploads/ -mindepth 1 -depth -type d -exec rmdir {} \;

