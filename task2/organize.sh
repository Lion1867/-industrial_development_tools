#!/usr/bin/env bash
# Задача 2. Организатор Downloads
# Использование: ./organize.sh <каталог>
# Раскладывает файлы из каталога по подпапкам images/ archives/ documents/ other/.
# Файлы с одинаковыми именами НЕ перезаписываются: photo.jpg -> photo_1.jpg, photo_2.jpg ...
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Использование: $0 <каталог>" >&2
    exit 1
fi

dir=$1
[[ -d $dir ]] || { echo "Ошибка: '$dir' не каталог" >&2; exit 1; }

shopt -s nullglob dotglob    # пустой glob -> ничего; учитываем скрытые файлы

mkdir -p "$dir"/{images,archives,documents,other}

for file in "$dir"/*; do
    [[ -f $file ]] || continue                 # только обычные файлы (папки пропускаем)
    name=$(basename -- "$file")
    [[ $name == .DS_Store ]] && continue       # служебный файл macOS не трогаем

    # расширение в нижнем регистре (photo.JPG -> jpg); у файла без точки — пусто
    if [[ $name == *.* && $name != .* ]]; then ext=${name##*.}; ext=${ext,,}; else ext=""; fi

    case $ext in
        jpg|jpeg|png|gif|bmp|svg|webp|tiff|heic)      target=images ;;
        zip|tar|gz|tgz|bz2|xz|7z|rar)                 target=archives ;;
        pdf|doc|docx|txt|odt|rtf|xls|xlsx|ppt|pptx|csv|md) target=documents ;;
        *)                                            target=other ;;
    esac

    # подбираем свободное имя, чтобы ничего не перезаписать
    dest="$dir/$target/$name"
    if [[ -e $dest ]]; then
        if [[ -n $ext ]]; then base=${name%.*}; suffix=".${name##*.}"; else base=$name; suffix=""; fi
        i=1
        while [[ -e "$dir/$target/${base}_$i$suffix" ]]; do (( i++ )); done
        dest="$dir/$target/${base}_$i$suffix"
    fi

    mv -n -- "$file" "$dest"                   # -n — подстраховка от перезаписи
    echo "$name -> $target/$(basename -- "$dest")"
done
