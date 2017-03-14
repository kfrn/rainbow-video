#!/usr/bin/env bash

input_file=$1 # Assign variable name to first argument
filename=$(basename "$input_file" | sed 's/\.[^.]*$//') # Gets rid of path and extension of input file
clean_filename=$(python3 ./fixfilename.py "$filename") # Gets rid of spaces, brackets, etc
echo "Original filename was $filename and clean filename is $clean_filename."

# Get duration of video in seconds; set number of frame captures ($divisor)
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file")
echo "Video length in seconds: $duration"
divisor=71 # To make 72 frame captures

# Set interval (in seconds) and time of first screengrab ($seek_time)
interval=$(echo "scale=0 ; $duration / $divisor" | bc)
int_mins=$(echo "scale=0 ; $interval / 60" | bc)
int_secs=$(echo "scale=0 ; $interval % 60" | bc)
seek_time=$int_mins:$int_secs
echo "First frame capture will be taken at:" $seek_time

# Create subdirectory for frame captures, first deleting if it already exists
output_folder=output-$clean_filename
if [[ -d "$output_folder" ]]; then
  rm -rf "$output_folder"
fi
mkdir "$output_folder"
echo "Frame captures will be saved into the subdirectory $output_folder"

# Create frame captures
ffmpeg -i "$input_file" -ss "$seek_time" -r 1/"$interval" ./"$output_folder"/"$clean_filename"_screencap_%02d.png -hide_banner
echo "Frame captures made."

# Depending on the video & interval, 73 frame captures may be made. Delete the 73rd if it exists
if [[ -f ./"$output_folder"/"$clean_filename"_screencap_73.png ]]; then
  rm -v ./"$output_folder"/"$clean_filename"_screencap_73.png
fi

files=$(ls ./"$output_folder"/*.png)
# Run Python script that orders image files by their dominant hue
echo "Now crunching the numbers. Stand by ..."
colour_order=$(python3 ./sortcolour.py $files)

# TODO?: use array directly in imagemagick command rather than making a text file
$(echo "$colour_order" > "$output_folder"/array.txt)
sed -i 's/\[//; s/]//' "$output_folder"/array.txt

# Make 6x12 composite image
montage @"$output_folder"/array.txt -tile 6x12 -geometry +0+0 "$output_folder"/"$clean_filename"_montage_fullsize.jpg
convert "$output_folder"/"$clean_filename"_montage_fullsize.jpg -resize 750 "$output_folder"/"$clean_filename"_montage_750w.jpg
echo "Composite images created."

# Remove the individual frame captures
rm ./"$output_folder"/*.png
rm ./"$output_folder"/*.txt
echo "Individual frame captures and text file deleted."
echo "$filename complete! Check the $output_folder subdirectory for the composite image file outputs."
