#!/bin/bash
set -eo pipefail

banner="==========="

# Configure projects
while read -r preset ; do
    if [ -n "$preset" ] && [[ $preset != \#* ]] ; then
        echo "${banner} Configuring $preset ${banner}"
        cmake -S . --preset "$preset" "-DPRESET_LABEL=$preset"
    fi
done < <(cat presets.lst; echo)

# Build projects
while read -r preset ; do
    if [ -n "$preset" ] && [[ $preset != \#* ]] ; then
        echo "${banner} Building $preset ${banner}"
        cmake --build --preset "$preset"
    fi
done < <(cat presets.lst; echo)

# Install projects
for i in build/* ; do
    if [ -d "$i" ]; then
        echo "${banner} Installing $i ${banner}"
        cmake --install "$i"
    fi
done
