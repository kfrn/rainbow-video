#!/usr/bin/env bash

input_file=$1

if ! [[ "$input_file" ]]; then
  echo "Please pass a video file as the first argument. Exiting"
  exit 1
fi

get_clean_filename() {
  local filename=$(basename "$1" | sed 's/\.[^.]*$//')  # Get rid of path and extension of input file

  clean_filename=$(python3 ./fixfilename.py "$filename") # Get rid of spaces, brackets, etc
}

duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file")
divisor=71  # To make 72 frame captures
interval=$(echo "scale=0 ; $duration / $divisor" | bc)

get_inital_framecapture_time() {
  local initial_capture_mins=$(echo "scale=0 ; $interval / 60" | bc)
  local initial_capture_secs=$(echo "scale=0 ; $interval % 60" | bc)

  seek_time="$initial_capture_mins":"$initial_capture_secs"
}

create_output_directory() {
  output_folder=output-"$clean_filename"

  if [[ -d "$output_folder" ]]; then
    rm -rf "$output_folder"
  fi

  mkdir "$output_folder"
}

create_frame_captures() {
  ffmpeg -i "$input_file" -ss "$seek_time" -r 1/"$interval" ./"$output_folder"/"$clean_filename"_screencap_%02d.png -hide_banner
}

remove_extra_frames() {
  for num in {73..99}
  do
    if [[ -f ./"$output_folder"/"$clean_filename"_screencap_"$num".png ]]; then
      rm -v ./"$output_folder"/"$clean_filename"_screencap_"$num".png
    fi
  done
}

generate_hue_order_list() {
  local files=$(ls ./"$output_folder"/*.png)

  echo "Now crunching the numbers. This might take a while. Stand by ..."
  colour_order=$(python3 ./sortcolour.py $files)

  $(echo "$colour_order" > "$output_folder"/array.txt)

  sed -i 's/\[//; s/]//' "$output_folder"/array.txt  # Remove enclosing square brackets
}

generate_mosaic_image() {
  montage @"$output_folder"/array.txt -tile 6x12 -geometry +0+0 "$output_folder"/"$clean_filename"_montage_fullsize.jpg
  convert "$output_folder"/"$clean_filename"_montage_fullsize.jpg -resize 750 "$output_folder"/"$clean_filename"_montage_750w.jpg
}

remove_individual_framecaptures() {
  rm ./"$output_folder"/*.png
  rm ./"$output_folder"/*.txt
  echo "Individual frame captures and text file deleted."
}


get_clean_filename "$input_file"
echo "Clean filename is: $clean_filename"
echo "Video length in seconds is: $duration"

get_inital_framecapture_time
echo "First frame capture will be taken at: $seek_time"

create_output_directory
echo "Frame captures will be saved into the subdirectory: $output_folder"

create_frame_captures
remove_extra_frames
echo "Frame captures complete."

generate_hue_order_list
echo "Number crunching done!"

generate_mosaic_image
echo "Composite images created."

remove_individual_framecaptures

echo "$filename complete! Check the $output_folder subdirectory for the composite image file outputs."
