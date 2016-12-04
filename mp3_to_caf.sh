#!/bin/sh
echo 'please input target directory: ' 
read path
path=${PWD%/}/$path
cd $path
echo 'converting...'
for i in *.mp3; do
     filename=${i%.*};
     afconvert -f caff -d ima4 $i $filename.caf
     echo "$filename.caf done."
done
