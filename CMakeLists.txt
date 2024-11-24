cmake_minimum_required(VERSION 3.0.0...3.24 FATAL_ERROR)
project(webgpu-podman
    VERSION 1.0.0
    LANGUAGES C CXX
    )

include(GNUInstallDirs)

set(WEBGPU_BACKEND "WGPU" CACHE STRING "Backend implementation of WebGPU. Possible values are EMSCRIPTEN, WGPU, WGPU_STATIC and DAWN (it does not matter when using emcmake)")
set_property(CACHE WEBGPU_BACKEND PROPERTY STRINGS EMSCRIPTEN WGPU WGPU_STATIC DAWN)

string(TOUPPER ${WEBGPU_BACKEND} WEBGPU_BACKEND_U)

if (NOT CMAKE_SYSTEM_NAME)
    message(FATAL_ERROR "CMAKE_SYSTEM_NAME not set.")
endif()
if (NOT CMAKE_SYSTEM_PROCESSOR)
    message(FATAL_ERROR "CMAKE_SYSTEM_PROCESSOR not set.")
endif()
string(TOLOWER "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}" WEBGPU_BUILD_FLAVOR)

message(STATUS "Configuring WebGPU for ${WEBGPU_BUILD_FLAVOR} (${PRESET_LABEL})")

if (EMSCRIPTEN OR WEBGPU_BACKEND_U STREQUAL "EMSCRIPTEN")
    install(
        DIRECTORY
            "webgpu-backend-emscripten/include/webgpu"
        DESTINATION
            "${CMAKE_INSTALL_INCLUDEDIR}"
    )

elseif (WEBGPU_BACKEND_U STREQUAL "WGPU")
    if (MSVC OR MINGW)
        install(
            FILES
                "webgpu-backend-wgpu/bin/${WEBGPU_BUILD_FLAVOR}/wgpu_native.dll"
            DESTINATION
                "${CMAKE_INSTALL_BINDIR}"
        )
        install(
            FILES
                "webgpu-backend-wgpu/bin/${WEBGPU_BUILD_FLAVOR}/wgpu_native.dll.lib"
            DESTINATION
                "${CMAKE_INSTALL_LIBDIR}"
        )
    else()
        install(
            FILES
                "webgpu-backend-wgpu/bin/${WEBGPU_BUILD_FLAVOR}/libwgpu_native.so"
            DESTINATION
                "${CMAKE_INSTALL_BINDIR}"
        )
    endif()
    install(
        DIRECTORY
            "webgpu-backend-wgpu/include/webgpu"
        DESTINATION
            "${CMAKE_INSTALL_INCLUDEDIR}"
    )

elseif (WEBGPU_BACKEND_U STREQUAL "WGPU_STATIC")
    if (MSVC OR MINGW)
        install(
            FILES
                "webgpu-backend-wgpu-static/lib/${WEBGPU_BUILD_FLAVOR}/wgpu_native.lib"
            DESTINATION
                "${CMAKE_INSTALL_LIBDIR}"
        )
    else()
        install(
            FILES
            "webgpu-backend-wgpu-static/lib/${WEBGPU_BUILD_FLAVOR}/libwgpu_native.a"
            DESTINATION
                "${CMAKE_INSTALL_LIBDIR}"
        )
    endif()

    install(
        DIRECTORY
            "webgpu-backend-wgpu-static/include/webgpu"
        DESTINATION
            "${CMAKE_INSTALL_INCLUDEDIR}"
    )

elseif (WEBGPU_BACKEND_U STREQUAL "DAWN")
    add_subdirectory(webgpu-backend-dawn)

    # Force dawn to build
    add_library(dawn-phony SHARED)
    target_link_libraries(dawn-phony PUBLIC webgpu_dawn)

    install(TARGETS
        webgpu_dawn
    )

    install(
        DIRECTORY
            "webgpu-backend-dawn/include/webgpu"
        DESTINATION
            "${CMAKE_INSTALL_INCLUDEDIR}"
    )

else()
    message(FATAL_ERROR "Invalid value for WEBGPU_BACKEND: possible values are EMSCRIPTEN, WGPU, WGPU_STATIC and DAWN, but '${WEBGPU_BACKEND_U}' was provided.")
endif()
