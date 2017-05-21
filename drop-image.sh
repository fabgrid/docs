#!/bin/bash

################################################################################
# Import an image and resize it.
################################################################################

DEFAULT_BASE="src/fabacademy"
DEFAULT_MAXSIZE=1200
DEFAULT_QUALITY=85


## Check if imagemagick is present
CONVERT_BIN=$(which convert)
 if [ ! -x "$CONVERT_BIN" ] ; then
    echo "'convert' not found in PATH. Is Imagemagick installed?"
    exit 1
 fi


## Determine location of trash directory
if [ -d "$HOME/.local/share/Trash" ]; then
	TRASH_PATH="$HOME/.local/share/Trash/"
elif [ -d "$HOME/.Trash" ]; then
	TRASH_PATH="$HOME/.Trash/"
fi

## Check if pbcopy exists
if [ -x "$(which pbcopy)" ] ; then
	PBCOPY_EXISTS=true
else
	PBCOPY_EXISTS=false
fi

## Gather info on source file
source=$1
if [ ! -f "$source" ]; then
	echo "The source is not a regular file! ($source)"
	exit 1
fi
extension="${source##*.}"


## Determine base directory
read -p "Base [$DEFAULT_BASE]: " -e base_dir
base_dir="${base_dir:-$DEFAULT_BASE}"

if [ ! -d "$base_dir" ]; then
	echo "Base directory '$base_dir' does not exist!"
	exit 1
fi


## Determine subdirectory
default_sub="`find $base_dir -type d -iname "week-*" | sort -t '-' -k 2n | tail -n1`"  # last folder matching week-*
default_sub="${default_sub##$base_dir/}"  # remove leading 'fabacademy/'

read -p "Subdirectory [$default_sub]: " -e sub_dir
sub_dir="${sub_dir:-$default_sub}"
target_dir="$base_dir/$sub_dir"

if [ ! -d "$target_dir" ]; then
	echo "Target directory '$target_dir' does not exist!"
	exit 1
fi


## Find next index
index=0
while [ true ]; do
	index=$(($index+1))
	padded_index=`printf "%02d" $index`
	if ! (ls $target_dir/$padded_index-* 1> /dev/null 2>&1); then
		break
	fi
done


## Ask for filename
read -p "Filename (without extension): $padded_index-" -e filename
filename="$padded_index-$filename.$extension"
target_path="$target_dir/$filename"


## Ask for scaling
read -p "Max dimensions (px) [$DEFAULT_MAXSIZE]: " -e max_size
max_size=${max_size:-$DEFAULT_MAXSIZE}


## Ask for quality
read -p "Quality [$DEFAULT_QUALITY]: " -e quality
quality=${quality:-$DEFAULT_QUALITY}


## Perform copy/conversion
$CONVERT_BIN "$source" -resize $max_sizex$max_size\> -quality $quality "$target_path"
if [ ! $? -eq 0 ]; then
	exit 1
fi

echo "Successfully copied to $target_path"


## Delete original?
DEFAULT_DELETE=n
read -p "Delete original file? [n]: " -e delete
delete=${delete:-$DEFAULT_DELETE}

if [ "$delete" == "y" ] || [ "$delete" == "yes" ] || [ "$delete" == "Y" ]; then
	if [ -z "$TRASH_PATH" ]; then
		rm "$source"
		echo "File deleted."
	else
		mv "$source" "$TRASH_PATH"
		echo "File moved to trash"
	fi
fi

## Copy path to clipboard?
if [ $PBCOPY_EXISTS ]; then
	echo -n "$filename"|pbcopy
	echo "Filename copied to clipboard: $filename"
fi

exit 0
