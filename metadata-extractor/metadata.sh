#!/bin/bash
clear
cat banner.txt

echo "Installing required packages..."
pkg update -y
pkg upgrade -y
pkg install python -y
pkg install git -y
pkg install wget -y

pip install --upgrade pip
pip install exifread
pip install pillow
pip install hachoir

echo ""
echo "Usage: bash metadata.sh <file-path>"
echo ""

if [ -z "$1" ]; then
    echo "Please provide a file path!"
    exit 1
fi

FILE="$1"

echo "Extracting metadata for: $FILE"
echo "---------------------------------"

# Method 1: Using exifread (for images, pdf)
python - <<END
import sys
import exifread
file_path = "$FILE"
with open(file_path, 'rb') as f:
    tags = exifread.process_file(f)
for tag in tags.keys():
    print(f"{tag}: {tags[tag]}")
END

# Method 2: Using hachoir (for videos, audio, docs)
python - <<END
from hachoir.parser import createParser
from hachoir.metadata import extractMetadata
parser = createParser("$FILE")
if not parser:
    print("Could not parse file.")
    exit(1)
metadata = extractMetadata(parser)
if metadata:
    for item in metadata.exportPlaintext():
        print(item)
END

echo ""
echo "Metadata extraction completed ✅"
