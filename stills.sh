#!bin/bash/

raspistill -o /var/www/stills/img%1d.jpg -t 10000 -tl 1000 -q 50 -w 800 -h 600
convert -define jpeg:size=500x180 /var/www/stills/*.jpg -auto-orient -thumbnail 300x -unsharp 0x.5 /var/www/stills/thumbnails/thumbs%1d.jpg

rm thumbs0.jpg

zip -j thumbsZip /var/www/stills/thumbnails/*
