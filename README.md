# WebGPU Precompiled Binaries

This pulls [Elie Michel's `WebGPU-distribution` package](https://github.com/eliemichel/WebGPU-distribution) and enables installation via `cmake --install`.

## Motivation

Elie's original repository relies on CMake `FetchContent` to fetch the either Dawn or wgpu-native. This is likely fine for most cases, but if you frequently trash your build directory, or are building from a Docker/Podman container, then installing the libraries into your sysroot is more efficient.

## Building/Installing: Automatic (Debian Only)

One-stop setup-build-install:

```
auto-build-install.sh
```

This will install the requisite libaries using `apt`, configure, build and install to `/opt/webgpu-dist`, for all enabled/supported architectures available to your system. (Use `dpkg --add-architecture` to build for foreign architectures.)

This script takes an optional path argument if you wish to customize the install destination.

## Building/Installing: Manual

Set up:

* Install the dependencies (Debian packages are provided in `auto-build-install.sh`), including for foreign architectures.
* Run `cmake --list-presets` to see which targets are available.

Build a single target:

```
cmake -S . --preset <preset>
cmake --build --preset <preset> --config Release
cmake --install build/<triple> --prefix <destination>
```

## Usage

The installed distribution is structured like so:

```
<install_root>/<wgpu_backend>/<target>/{bin,include,lib}
```

Where:

* `install_root`: the installation target (`/opt/webgpu-dist` by default)
* `wgpu_backend`: one of the possible backends listed below
* `target`: one of the possible targets listed below

Backends:

* `dawn`: the Dawn backend
* `wgpu`: the wgpu-native shared library backend
* `wgpu-static`: the wpu-native static libary backend
* `emscripten`: the Emscripten backend

Targets:

* `linux-x86_64`
* `linux-aarch64`
* `windows-x86_64`
* `emscripten-wasm32`

For example, if you are building for Windows with wgpu-static, use:

* Include path: `<install path>/wgpu-static/windows-x86_64/include`
* Library path: `<install path>/wgpu-static/windows-x86_64/lib`
* Link to: `wgpu_native`

# To-Do

* The Visual Studio (MSVC) builds are untested
* The Windows Dawn build cannot be run on Linux build hosts
* `i686` support for Windows is unimplemented

Note: Dawn doesn't build in Mingw64 due to problems with the upstream Dawn project.
