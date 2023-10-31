#!/bin/sh

dir='/opt/mon'
max_files=10

filename=$(date +"%b_%d_%H_%M_%S")

echo "File has been created:$dir/$filename.log"

file="$dir/$filename.log"
ps -eo %cpu,pid,user,cmd | head -n 6 | awk '{print $2,$1,$3,$4}' >> $file

if [ "$(ls -A "$dir" | wc -l)" -gt "$max_files" ]; then
	files=$(ls -a $dir)
	files_sorted=$(ls -ttr $dir)
	oldest_file=${files_sorted::$((${#files_sorted}-1))}
	rm -f $dir/$oldest_file
fi
