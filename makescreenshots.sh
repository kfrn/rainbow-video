#!/usr/bin/env bash

# Assign variable name to first argument
input_file=$1

# Extracts the name of the input file. e.g., './test/input-file.avi' -> 'input-file'
filename=$(basename "$input_file")
filename="${filename%%.*}"

# Get duration of video in seconds; set number of frame captures ($divisor)
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $input_file)
echo "Video length in seconds:" $duration
# divisor=71 # To make 72 frame captures
divisor=5 # Will make 6 frame captures

# Set interval (in seconds) and time of first screengrab ($seek_time)
interval=$(echo "scale=0 ; $duration / $divisor" | bc)
int_mins=$(echo "scale=0 ; $interval / 60" | bc)
int_secs=$(echo "scale=0 ; $interval % 60" | bc)
seek_time=$int_mins:$int_secs
echo "First frame capture will be taken at:" $seek_time

# Create subdirectory for frame captures
output_folder=output-$filename
mkdir $output_folder
echo "Frame captures will be saved into subdirectory" $output_folder
ffmpeg -ss $seek_time -i $input_file -r 1/$interval ./$output_folder/"$filename"_screencap_%02d.png -hide_banner

# Make basic composite image
convert -append "$output_folder"/*.png "$output_folder"/"$filename"_composite.jpg
