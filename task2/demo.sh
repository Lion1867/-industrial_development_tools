#!/usr/bin/env bash
# Демонстрация всех трёх задач на данных из data/*.zip.
# Работает на копиях в каталоге demo/, исходные данные не трогает.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf demo && mkdir demo
unzip -q -o data/01.zip -x '__MACOSX/*' -d demo
unzip -q -o data/02.zip -x '__MACOSX/*' -d demo

echo "===== Задача 1: *.txt >= 1K в demo/01 ====="
./find_files.sh demo/01 txt 1K

echo
echo "===== Задача 2: разбираем «грязную» папку Downloads ====="
dl=demo/Downloads
mkdir -p "$dl"
# берём файлы из 02.zip и сваливаем в одну кучу
find demo/02/downloads -type f -exec cp {} "$dl"/ \;
echo "второе фото" > "$dl/Photo.jpg"
echo "текст с пробелом" > "$dl/my notes.txt"
echo "без расширения" > "$dl/README"
echo "До:"; ls -1 "$dl"
./organize.sh "$dl"
# второй прогон с тем же именем — проверяем, что нет перезаписи
echo "ещё одно фото" > "$dl/photo.JPG"
./organize.sh "$dl"
echo "После:"; find "$dl" -type f | sort

echo
echo "===== Задача 3: дубликаты ====="
echo "-- на исходных данных:"
./find_dups.sh demo/01
echo "-- добавим копии и проверим снова:"
cp demo/01/files/b.txt "demo/01/files/sub/b copy.txt"
cp demo/01/files/sub/c.txt demo/01/c_backup.txt
cp demo/01/files/sub/c.txt demo/01/files/c_old.txt
./find_dups.sh demo/01
