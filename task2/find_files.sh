#!/usr/bin/env bash
# usage: ./find_files.sh <dir> <ext> <min_size>   (size: 100, 5K, 2M, 1G)
set -euo pipefail

if [ $# -ne 3 ]; then
    echo "usage: $0 <dir> <ext> <min_size>" >&2
    exit 1
fi

dir=$1
ext=${2#.}
size=$3

if [ ! -d "$dir" ]; then
    echo "$dir: not a directory" >&2
    exit 1
fi

case ${size^^} in
    *K) bytes=$(( ${size%[kK]} * 1024 )) ;;
    *M) bytes=$(( ${size%[mM]} * 1024 * 1024 )) ;;
    *G) bytes=$(( ${size%[gG]} * 1024 * 1024 * 1024 )) ;;
    *[!0-9]*|"") echo "bad size: $size" >&2; exit 1 ;;
    *) bytes=$size ;;
esac

# find -size +N значит "строго больше", поэтому N-1
opts=()
if [ "$bytes" -gt 0 ]; then
    opts=(-size +$(( bytes - 1 ))c)
fi

find "$dir" -type f -iname "*.$ext" "${opts[@]}" \
    -printf '%s\t%TY-%Tm-%Td %TH:%TM\t%p\n' | sort -t $'\t' -k1,1nr
