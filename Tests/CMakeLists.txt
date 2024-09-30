# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

cmake_minimum_required (VERSION 3.20)

project (fmtconvert
    DESCRIPTION "D3DX_DXGIFormatConvert.inl Tester"
    HOMEPAGE_URL "https://github.com/walbourn/dxgiformatconvert"
    LANGUAGES CXX)


option(ENABLE_CODE_ANALYSIS "Use Static Code Analysis on build" OFF)

option(BUILD_DXIL_SHADERS "Use DXC Shader Model 6 for shaders" OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

if(DEFINED VCPKG_TARGET_ARCHITECTURE)
    set(DIRECTX_ARCH ${VCPKG_TARGET_ARCHITECTURE})
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Ww][Ii][Nn]32$")
    set(DIRECTX_ARCH x86)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Xx]64$")
    set(DIRECTX_ARCH x64)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Aa][Rr][Mm]$")
    set(DIRECTX_ARCH arm)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Aa][Rr][Mm]64$")
    set(DIRECTX_ARCH arm64)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Aa][Rr][Mm]64EC$")
    set(DIRECTX_ARCH arm64ec)
elseif(CMAKE_VS_PLATFORM_NAME_DEFAULT MATCHES "^[Ww][Ii][Nn]32$")
    set(DIRECTX_ARCH x86)
elseif(CMAKE_VS_PLATFORM_NAME_DEFAULT MATCHES "^[Xx]64$")
    set(DIRECTX_ARCH x64)
elseif(CMAKE_VS_PLATFORM_NAME_DEFAULT MATCHES "^[Aa][Rr][Mm]$")
    set(DIRECTX_ARCH arm)
elseif(CMAKE_VS_PLATFORM_NAME_DEFAULT MATCHES "^[Aa][Rr][Mm]64$")
    set(DIRECTX_ARCH arm64)
elseif(CMAKE_VS_PLATFORM_NAME_DEFAULT MATCHES "^[Aa][Rr][Mm]64EC$")
    set(DIRECTX_ARCH arm64ec)
endif()

add_executable(${PROJECT_NAME}
    fmtconvert.cpp)

target_include_directories(${PROJECT_NAME} PRIVATE ../)

# Build HLSL shaders
if(BUILD_DXIL_SHADERS AND VCPKG_TOOLCHAIN)
    set(ShaderProfile "cs_6_0")
    find_program(DIRECTX_DXC_TOOL DXC.EXE
        REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH NO_DEFAULT_PATH
        HINTS ${DIRECTX_DXC_PATH}
            "${CMAKE_CURRENT_LIST_DIR}/build/vcpkg_installed/${VCPKG_HOST_TRIPLET}/tools/directx-dxc")
    set(ShaderOpts "-HV 2021")
    message(STATUS "Using VCPKG for DirectXShaderCompiler (${VCPKG_HOST_TRIPLET}).")
elseif(BUILD_DXIL_SHADERS)
    set(ShaderProfile "cs_6_0")
    find_program(DIRECTX_DXC_TOOL DXC.EXE
        HINTS "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_SYSTEM_VERSION}/${DIRECTX_HOST_ARCH}"
            "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}/${DIRECTX_HOST_ARCH}")

    if(NOT (DIRECTX_DXC_TOOL MATCHES "10\.0\.19041\.0|10\.0\.20348\.0|10\.0\.22000.0"))
        set(ShaderOpts "-HV 2021")
    endif()

    message(STATUS "Using DirectXShaderCompiler found in ${DIRECTX_DXC_TOOL}")
else()
    set(ShaderProfile "cs_5_0")
    find_program(DIRECTX_DXC_TOOL FXC.EXE
        HINTS "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_SYSTEM_VERSION}/${DIRECTX_HOST_ARCH}"
            "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}/${DIRECTX_HOST_ARCH}")
    set(ShaderOpts "")

    message(STATUS "Using LegacyShaderCompiler found in ${DIRECTX_FXC_TOOL}")
endif()

add_custom_target(shaders)

foreach(FILE F10UN.hlsl F10UI.hlsl
   F8U.hlsl F8US.hlsl F8UI.hlsl F8S.hlsl F8SI.hlsl FB8U.hlsl FB8US.hlsl FBX8U.hlsl FBX8US.hlsl
   F16F.hlsl F16U.hlsl F16UI.hlsl F16S.hlsl F16SI.hlsl)
  set_source_files_properties(${FILE} PROPERTIES ShaderType "cs")
  get_filename_component(FILE_WE ${FILE} NAME_WE)
  add_custom_command(TARGET shaders
                     COMMAND ${DIRECTX_DXC_TOOL} /nologo /Ges /Gis /Emain /T${ShaderProfile} ${ShaderOpts} $<$<CONFIG:DEBUG>:/Od> /Zi /Fo ${CMAKE_BINARY_DIR}/${FILE_WE}.cso /Fd ${CMAKE_BINARY_DIR}/${FILE_WE}.pdb ${FILE}
                     MAIN_DEPENDENCY ${FILE}
                     COMMENT "HLSL ${FILE}"
                     WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                     VERBATIM)
endforeach(FILE)

add_dependencies(${PROJECT_NAME} shaders)

if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /Wall /EHsc /GR "$<$<NOT:$<CONFIG:DEBUG>>:/guard:cf>")
    target_link_options(${PROJECT_NAME} PRIVATE "$<$<NOT:$<CONFIG:DEBUG>>:/guard:cf>" /DYNAMICBASE /NXCOMPAT)

    if((CMAKE_SIZEOF_VOID_P EQUAL 4) AND (NOT ${DIRECTX_ARCH} MATCHES "^arm"))
        target_link_options(${PROJECT_NAME} PRIVATE /SAFESEH)
    endif()

    if((MSVC_VERSION GREATER_EQUAL 1928)
       AND (CMAKE_SIZEOF_VOID_P EQUAL 8)
       AND ((NOT (CMAKE_CXX_COMPILER_ID MATCHES "Clang|IntelLLVM")) OR (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 13.0)))
        target_compile_options(${PROJECT_NAME} PRIVATE "$<$<NOT:$<CONFIG:DEBUG>>:/guard:ehcont>")
        target_link_options(${PROJECT_NAME} PRIVATE "$<$<NOT:$<CONFIG:DEBUG>>:/guard:ehcont>")
    endif()
else()
    list(APPEND COMPILER_DEFINES $<IF:$<CONFIG:DEBUG>,_DEBUG,NDEBUG>)
endif()

if(NOT ${DIRECTX_ARCH} MATCHES "^arm")
    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(ARCH_SSE2 $<$<CXX_COMPILER_ID:MSVC,Intel>:/arch:SSE2> $<$<NOT:$<CXX_COMPILER_ID:MSVC,Intel>>:-msse2>)
    else()
        set(ARCH_SSE2 $<$<NOT:$<CXX_COMPILER_ID:MSVC,Intel>>:-msse2>)
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        list(APPEND ARCH_SSE2 -mfpmath=sse)
    endif()

    target_compile_options(${PROJECT_NAME} PRIVATE ${ARCH_SSE2})
endif()

if(MINGW)
    find_package(directxmath CONFIG REQUIRED)
else()
    find_package(directxmath CONFIG QUIET)
endif()

if(directxmath_FOUND)
    message(STATUS "Using DirectXMath package")
    target_link_libraries(${PROJECT_NAME} PUBLIC Microsoft::DirectXMath)
endif()


if(BUILD_DXIL_SHADERS AND VCPKG_TOOLCHAIN)
    message(STATUS "Using VCPKG for DirectXShaderCompiler (${VCPKG_HOST_TRIPLET}).")
    find_program(DIRECTX_DXC_TOOL DXC.EXE
        REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH NO_DEFAULT_PATH
        HINTS ${DIRECTX_DXC_PATH}
            "${CMAKE_CURRENT_LIST_DIR}/build/vcpkg_installed/${VCPKG_HOST_TRIPLET}/tools/directx-dxc")
elseif(BUILD_DXIL_SHADERS)
    find_program(DIRECTX_DXC_TOOL DXC.EXE
        HINTS "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_SYSTEM_VERSION}/${DIRECTX_HOST_ARCH}"
            "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}/${DIRECTX_HOST_ARCH}")
    message(STATUS "Using DirectXShaderCompiler found in ${DIRECTX_DXC_TOOL}")
else()
    find_program(DIRECTX_FXC_TOOL FXC.EXE
        HINTS "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_SYSTEM_VERSION}/${DIRECTX_HOST_ARCH}"
            "C:/Program Files (x86)/Windows Kits/10/bin/${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}/${DIRECTX_HOST_ARCH}")
    message(STATUS "Using LegacyShaderCompiler found in ${DIRECTX_FXC_TOOL}")
endif()

if(MINGW)
    target_link_options(${PROJECT_NAME} PRIVATE -municode)
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|IntelLLVM")
    target_compile_options(${PROJECT_NAME} PRIVATE
        "-Wpedantic" "-Wextra" "-Wno-c++98-compat"
        "-Wno-c++98-compat-pedantic" "-Wno-gnu-anonymous-struct"
        "-Wno-language-extension-token" "-Wno-missing-prototypes" "-Wno-missing-variable-declarations" "-Wno-nested-anon-types")

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 16.0)
        target_compile_options(${PROJECT_NAME} PRIVATE /ZH:SHA_256 "-Wno-unsafe-buffer-usage")
    endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wno-ignored-attributes)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel")
    target_compile_options(${PROJECT_NAME} PRIVATE /Zc:__cplusplus /Zc:inline /fp:fast /Qdiag-disable:161)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    target_compile_options(${PROJECT_NAME} PRIVATE
        /sdl /Zc:inline /fp:fast
        "/wd4061" "/wd4365" "/wd4514" "/wd4571" "/wd4668" "/wd4710" "/wd4820" "/wd5031" "/wd5032" "/wd5039" "/wd5045")

    if(ENABLE_CODE_ANALYSIS)
        target_compile_options(${PROJECT_NAME} PRIVATE /analyze)
    endif()

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.10)
        target_compile_options(${PROJECT_NAME} PRIVATE /permissive-)
    endif()

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.14)
        target_compile_options(${PROJECT_NAME} PRIVATE /Zc:__cplusplus)
    endif()

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.24)
        target_compile_options(${PROJECT_NAME} PRIVATE /ZH:SHA_256)
    endif()

    if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.26)
        target_compile_options(${PROJECT_NAME} PRIVATE /Zc:preprocessor /wd5105)
    endif()

    if((CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.27) AND (NOT (${DIRECTX_ARCH} MATCHES "^arm")))
        target_link_options(${PROJECT_NAME} PRIVATE /CETCOMPAT)
    endif()

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.28)
        target_compile_options(${PROJECT_NAME} PRIVATE /Zc:lambda)
    endif()

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.29)
        target_compile_options(${PROJECT_NAME} PRIVATE /external:W4)
    endif()

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.34)
        target_compile_options(${PROJECT_NAME} PRIVATE /wd5262 /wd5264)
    endif()

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.35)
        target_compile_options(${PROJECT_NAME} PRIVATE $<$<VERSION_GREATER_EQUAL:${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION},10.0.22000>:/Zc:templateScope>)
    endif()
endif()

if(WIN32)
    target_compile_definitions(${PROJECT_NAME} PRIVATE _UNICODE UNICODE _WIN32_WINNT=0x0602)
endif()
