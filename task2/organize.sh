#!/usr/bin/env bash
# usage: ./organize.sh <dir>
set -euo pipefail

if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    echo "usage: $0 <dir>" >&2
    exit 1
fi

dir=$1
shopt -s nullglob dotglob
mkdir -p "$dir"/{images,archives,documents,other}

for f in "$dir"/*; do
    [ -f "$f" ] || continue
    name=$(basename -- "$f")
    [ "$name" = ".DS_Store" ] && continue

    ext=""
    if [[ $name == *.* && $name != .* ]]; then
        ext=${name##*.}
        ext=${ext,,}
    fi

    case $ext in
        jpg|jpeg|png|gif|bmp|svg|webp|heic) dest=images ;;
        zip|tar|gz|tgz|bz2|xz|7z|rar) dest=archives ;;
        pdf|doc|docx|odt|rtf|txt|md|csv|xls|xlsx|ppt|pptx) dest=documents ;;
        *) dest=other ;;
    esac

    target="$dir/$dest/$name"
    # если такое имя уже есть - добавляем _1, _2, ...
    if [ -e "$target" ]; then
        if [ -n "$ext" ]; then
            base=${name%.*}
            suf=".${name##*.}"
        else
            base=$name
            suf=""
        fi
        i=1
        while [ -e "$dir/$dest/${base}_$i$suf" ]; do
            i=$((i + 1))
        done
        target="$dir/$dest/${base}_$i$suf"
    fi

    mv -n -- "$f" "$target"
    echo "$name -> $dest/$(basename -- "$target")"
done
