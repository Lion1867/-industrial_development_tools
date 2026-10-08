#!/usr/bin/env bash
# Задача 3. Поиск дубликатов
# Использование: ./find_dups.sh <каталог>
# Находит одинаковые по содержимому файлы (по sha256), выводит группы
# и сколько места освободится, если оставить по одному файлу из группы.
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Использование: $0 <каталог>" >&2
    exit 1
fi

dir=$1
[[ -d $dir ]] || { echo "Ошибка: '$dir' не каталог" >&2; exit 1; }

declare -A files_by_hash   # хеш -> список путей (через \n)
declare -A count_by_hash   # хеш -> сколько файлов
declare -A size_by_hash    # хеш -> размер одного файла

# -print0 + read -d '' — корректно работаем с пробелами в именах
while IFS= read -r -d '' f; do
    hash=$(sha256sum -- "$f" | awk '{print $1}')
    files_by_hash[$hash]+="$f"$'\n'
    count_by_hash[$hash]=$(( ${count_by_hash[$hash]:-0} + 1 ))
    size_by_hash[$hash]=$(stat -c %s -- "$f")
done < <(find "$dir" -type f -print0)

groups=0
total_free=0
for hash in "${!count_by_hash[@]}"; do
    n=${count_by_hash[$hash]}
    (( n > 1 )) || continue
    (( ++groups ))
    size=${size_by_hash[$hash]}
    free=$(( size * (n - 1) ))
    (( total_free += free ))
    echo "Группа $groups: $n файла(ов) по $size Б, sha256=${hash:0:12}…, можно освободить $free Б"
    printf '%s' "${files_by_hash[$hash]}" | sed 's/^/    /'
done

if (( groups == 0 )); then
    echo "Дубликатов не найдено."
else
    echo "Итого групп: $groups, можно освободить: $total_free Б ($(numfmt --to=iec "$total_free"))"
fi
