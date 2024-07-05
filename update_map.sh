#!/bin/bash

# Check for newest file

directory="/home/timwang/.minecraft/saves"
input_dir="Walnut203 (World 1)"
today=$(date +"%Y%m%d")
target_dir="Walnut203_$today"
output_dir=$target_dir
current_dir=$(pwd)
viewer_dir="/home/timwang/minecraft202406"
repo_url="https://github.com/tim-wang-285/Minecraft202406.git"
branch="main"

if [ "$current_dir" != "$viewer_dir" ]; then
  echo "Error: Script must run from $viewer_dir."
  exit 1
fi

isfile=0
for dir in "$directory"/*; do
  if [[ $(basename "$dir") == *"$input_dir"* ]]; then
    isfile=1
    counter=1
    for dir in "$directory"/*; do
      if [[ "$(basename "$dir")" == *"$target_dir"* ]]; then
        counter=$((counter + 1))
        output_dir="${target_dir}-${counter}"
      fi
    done
  fi
done

if [ "$isfile" == 0 ]; then
  echo "New file not found. Have you downloaded the save?"
  exit 1
fi

echo "Renaming downloaded save to ${directory}/${output_dir}."
mv "${directory}/${input_dir}" "${directory}/${output_dir}"

# Generate map
echo "Generating map using minedmap."
sudo /usr/bin/minedmap "${directory}/${output_dir}" "/home/timwang/minecraft202406/data"

# Push to GitHub
git commit -a -m "Update map version ${directory}/${output_dir}."
git push origin main
echo "Finished updating remote repo."
