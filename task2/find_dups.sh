#!/usr/bin/env bash
# usage: ./find_dups.sh <dir>
set -euo pipefail

if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    echo "usage: $0 <dir>" >&2
    exit 1
fi

declare -A paths count size

while IFS= read -r -d '' f; do
    h=$(sha256sum -- "$f" | awk '{print $1}')
    paths[$h]+="$f"$'\n'
    count[$h]=$(( ${count[$h]:-0} + 1 ))
    size[$h]=$(stat -c %s -- "$f")
done < <(find "$1" -type f -print0)

groups=0
total=0
for h in "${!count[@]}"; do
    n=${count[$h]}
    [ "$n" -gt 1 ] || continue
    groups=$((groups + 1))
    free=$(( size[$h] * (n - 1) ))
    total=$((total + free))
    echo "group $groups: $n files, ${size[$h]} bytes each (sha256 ${h:0:12})"
    printf '%s' "${paths[$h]}" | sed 's/^/  /'
done

if [ "$groups" -eq 0 ]; then
    echo "no duplicates"
else
    echo "can free: $total bytes ($(numfmt --to=iec "$total"))"
fi
