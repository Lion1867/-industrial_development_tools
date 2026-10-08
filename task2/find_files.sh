#!/usr/bin/env bash
# Задача 1. Умный поиск файлов
# Использование: ./find_files.sh <каталог> <расширение> <мин_размер>
#   мин_размер: в байтах или с суффиксом K/M/G (например 1000, 5K, 2M)
# Пример: ./find_files.sh data/01 txt 1K
set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Использование: $0 <каталог> <расширение> <мин_размер>" >&2
    exit 1
fi

dir=$1
ext=${2#.}          # разрешаем писать и "txt", и ".txt"
size=$3

[[ -d $dir ]] || { echo "Ошибка: '$dir' не каталог" >&2; exit 1; }

# Переводим размер в байты
case ${size^^} in
    *K) bytes=$(( ${size%[kK]} * 1024 )) ;;
    *M) bytes=$(( ${size%[mM]} * 1024 * 1024 )) ;;
    *G) bytes=$(( ${size%[gG]} * 1024 * 1024 * 1024 )) ;;
    *[!0-9]*|"") echo "Ошибка: неверный размер '$size'" >&2; exit 1 ;;
    *)  bytes=$size ;;
esac

echo "РАЗМЕР(Б)   ИЗМЕНЁН              ПУТЬ"
# -size +Nc = строго больше N байт, поэтому N = bytes-1 (т.е. >= bytes)
size_filter=()
(( bytes > 0 )) && size_filter=(-size +$(( bytes - 1 ))c)

# %s — размер, %TY-%Tm-%Td %TH:%TM:%.2TS — дата изменения, %p — путь
find "$dir" -type f -iname "*.${ext}" "${size_filter[@]}" \
     -printf '%s\t%TY-%Tm-%Td %TH:%TM:%.2TS\t%p\n' \
  | sort -t $'\t' -k1,1nr \
  | awk -F'\t' '{ printf "%-10s  %-19s  %s\n", $1, $2, $3 }'
