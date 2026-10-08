#!/usr/bin/env bash
# прогон всех трёх скриптов на данных из data/
set -euo pipefail
cd "$(dirname "$0")"

rm -rf demo
mkdir demo
unzip -q -o data/01.zip -x '__MACOSX/*' -d demo
unzip -q -o data/02.zip -x '__MACOSX/*' -d demo

echo "--- 1. find_files"
./find_files.sh demo/01 txt 1K

echo
echo "--- 2. organize"
dl=demo/Downloads
mkdir -p "$dl"
find demo/02/downloads -type f -exec cp {} "$dl"/ \;
echo test > "$dl/Photo.jpg"
echo test > "$dl/my notes.txt"
echo test > "$dl/README"
ls "$dl"
./organize.sh "$dl"
echo another > "$dl/photo.JPG"
./organize.sh "$dl"
find "$dl" -type f | sort

echo
echo "--- 3. find_dups"
./find_dups.sh demo/01
cp demo/01/files/b.txt "demo/01/files/sub/b copy.txt"
cp demo/01/files/sub/c.txt demo/01/c_backup.txt
cp demo/01/files/sub/c.txt demo/01/files/c_old.txt
./find_dups.sh demo/01
