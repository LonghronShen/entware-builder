#!/bin/bash
# liblinks - generate symbolic links
# given libx.so.0.0.0 this would generate links for libx.so.0.0, libx.so.0, libx.so

TARGET_LIB_DIR="${1:-/opt/lib}"

cd "$TARGET_LIB_DIR" || exit 0

LIBFILES=$(ls lib*.so.*)
for FILE in $LIBFILES; do
    echo "Linking $FILE"
    shortlib=$FILE
    basename=$FILE
    while
        extn=$(echo "$shortlib" | sed -n '/\.[0-9][0-9]*$/s/.*\(\.[0-9][0-9]*\)$/\1/p')
        [ -n "$extn" ]
    do
        shortlib=$(basename "$shortlib" "$extn")
        ln -fs "$basename" "$shortlib"
        basename=$shortlib
    done
done
