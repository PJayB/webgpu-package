#!/bin/bash
set -eo pipefail

banner="==========="

prefix="${1:-/opt/webgpu-dist}"

# The Linux prerequisites to install per-architecture
packages=(
    libx11-xcb-dev
    libxcursor-dev
    libxi-dev
    libxinerama-dev
    libxrandr-dev
    mesa-common-dev
)

# Get the list of architectures this host supports
readarray -t architectures < <(
    dpkg --print-architecture
    dpkg --print-foreign-architectures
)

mux_packages_architectures() {
    for package in "${packages[@]}"; do
        for arch in "${architectures[@]}"; do
            case "$arch" in
            arm64|amd64) echo "$package:$arch" ;;
            *) ;; # ignore architecture
            esac
        done
    done
}

# Install the packages for all supported architectures
mux_packages_architectures | xargs apt install -y

# Fetch the presets to build
readarray -t presets < <(cmake --list-presets=build | sed -rn 's/ *"([^"]+)"/\1/p')

# Configure projects
for preset in "${presets[@]}"; do
    echo "${banner} Configuring $preset ${banner}"
    # Errors ignored, as there are plenty of legit reasons for failure:
    # - some generators might not work on this platform
    # - some architectures might not be enabled
    cmake -S . -B "build/$preset" --preset "$preset" || :
done

# Build projects
for preset in "${presets[@]}"; do
    if [ -d "build/$preset" ]; then
        echo "${banner} Building $preset ${banner}"
        cmake --build "build/$preset" --preset "$preset" --config Release
    fi
done

# Install projects
for preset in "${presets[@]}"; do
    if [ -d "build/$preset" ]; then
        echo "${banner} Installing $preset ${banner}"
        cmake --install "build/$preset" --prefix "$prefix/$preset"
    fi
done
