# WebGPU Precompiled Binaries

This pulls (Elie Michel's `WebGPU-distribution` package)[https://github.com/eliemichel/WebGPU-distribution] and installs the binaries to `/opt/webgpu-dist` (by default).

## Motivation

Elie's original repository relies on CMake `FetchContent` to fetch the either Dawn or wgpu-native. This is likely fine for most cases, but if you frequently trash your build directory, or are building from a Docker/Podman container, then installing the libraries into your sysroot is more efficient.

## Building/Installing

Set up:

* Clone this repository
* Install the dependencies (Debian packages are provided in `apt-packages.lst`)
* Install dependencies for alternative targets, e.g. `arm64`

Build a single target:

```
cmake -S . --preset <preset>
cmake --build --preset <preset> --config Release
cmake --install build/<triple> --prefix <destination>
```

Build and all projects:

* Run `build.sh`

Presets:

```
# Linux AMD64
linux-x86_64-wgpu
linux-x86_64-wgpu-static
linux-x86_64-dawn

# Linux ARM64
linux-aarch64-wgpu
linux-aarch64-wgpu-static
linux-aarch64-dawn

# Web
emscripten

# Windows
windows-msvc-wgpu
windows-msvc-wgpu-static
windows-mingw64-wgpu
windows-mingw64-wgpu-static
```

## Usage

Point your compiler to one of the following subdirectories of `/opt/webgpu-dist`:

* `dawn`: the Dawn backend
* `wgpu`: the wgpu-native shared library backend
* `wgpu-static`: the wpu-native static libary backend
* `emscripten`: the Emscripten backend

Within these subdirectories you will find the includes, libraries and binaries for:

* `x86_64-linux-gnu/{bin,include,lib}/...`
* `aarch64-linux-gnu/{bin,include,lib}/...`
* `x86_64-w64-msvc/{bin,include,lib}/...`
* `x86_64-w64-mingw32/{bin,include,lib}/...`

For example, if you are building for Windows with wgpu-static, use:

* Include path: `<install path>/wgpu-static/x86_64-w64-msvc/include`
* Library path: `<install path>/wgpu-static/x86_64-w64-msvc/lib`
* Link to: `wgpu_native`

# To-Do

* The default install directory is not configurable when batch-building
* The Visual Studio (MSVC) builds are untested
* The MSVC builds also cannot be run on Linux build hosts

# Known Issues

* Mingw64 Dawn doesn't build due to problems with the upstream Dawn project
