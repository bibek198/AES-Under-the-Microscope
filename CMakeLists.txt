cmake_minimum_required(VERSION 3.20)
project(aes_under_the_microscope LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# We control optimisation flags ourselves (CMake's Release default would add -O3).
set(CMAKE_CXX_FLAGS_RELEASE "")
set(CMAKE_CXX_FLAGS_DEBUG "")

# Optimisation level used for the experiment binaries (Experiment E5 compares O0 vs O2).
set(AES_OPT_LEVEL "O2" CACHE STRING "Optimisation level for Release builds (O0, O1, O2, O3)")
option(AES_SANITIZE "Build with AddressSanitizer + UndefinedBehaviorSanitizer" OFF)

# OpenSSL 3 from Homebrew. macOS ships LibreSSL without OpenSSL headers.
if(APPLE AND NOT OPENSSL_ROOT_DIR)
  if(EXISTS "/opt/homebrew/opt/openssl@3")
    set(OPENSSL_ROOT_DIR "/opt/homebrew/opt/openssl@3")
  elseif(EXISTS "/usr/local/opt/openssl@3")
    set(OPENSSL_ROOT_DIR "/usr/local/opt/openssl@3")
  endif()
endif()
find_package(OpenSSL 3.0 REQUIRED COMPONENTS Crypto)

set(COMMON_WARNINGS -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wno-sign-conversion)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
  set(OPT_FLAGS -${AES_OPT_LEVEL})
  set(OPT_LABEL "-${AES_OPT_LEVEL}")
else()
  set(OPT_FLAGS -O0 -g)
  set(OPT_LABEL "-O0 -g")
endif()

# Target the M4 explicitly; this also enables the ARMv8 AES instructions.
include(CheckCXXCompilerFlag)
check_cxx_compiler_flag("-mcpu=apple-m4" HAS_MCPU_M4)
if(HAS_MCPU_M4)
  set(CPU_FLAGS -mcpu=apple-m4)
  set(CPU_LABEL "-mcpu=apple-m4")
else()
  set(CPU_FLAGS -march=armv8-a+crypto)
  set(CPU_LABEL "-march=armv8-a+crypto")
endif()

set(SAN_FLAGS "")
if(AES_SANITIZE)
  set(SAN_FLAGS -fsanitize=address,undefined -fno-omit-frame-pointer)
endif()

# Git commit (recorded in experiment metadata for reproducibility).
execute_process(COMMAND git rev-parse --short HEAD
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_HASH OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET)
if(NOT GIT_HASH)
  set(GIT_HASH "unknown")
endif()

set(BUILD_DEFS
  AES_OPT_LABEL="${OPT_LABEL}"
  AES_CPU_LABEL="${CPU_LABEL}"
  AES_GIT_HASH="${GIT_HASH}")

function(aes_configure tgt)
  target_include_directories(${tgt} PUBLIC ${CMAKE_SOURCE_DIR}/include)
  target_compile_options(${tgt} PRIVATE ${COMMON_WARNINGS} ${OPT_FLAGS} ${CPU_FLAGS} ${SAN_FLAGS})
  target_compile_definitions(${tgt} PRIVATE ${BUILD_DEFS})
  target_link_options(${tgt} PRIVATE ${SAN_FLAGS})
endfunction()

# --- Core cryptography (no timing code) -------------------------------------
add_library(aes_core STATIC
  src/aes_common.cpp
  src/aes_ref.cpp
  src/aes_ttable.cpp
  src/aes_ct.cpp
  src/aes_armv8.cpp
  src/aes_openssl.cpp
  src/controls.cpp
  src/trace.cpp
  src/factory.cpp)
aes_configure(aes_core)
target_link_libraries(aes_core PUBLIC OpenSSL::Crypto)

# --- Measurement harness ------------------------------------------------------
add_library(aes_harness STATIC
  src/timer.cpp
  src/harness.cpp
  src/bench.cpp
  src/metadata.cpp
  src/json_out.cpp
  src/selftest.cpp)
aes_configure(aes_harness)
target_link_libraries(aes_harness PUBLIC aes_core)

# --- Main CLI -----------------------------------------------------------------
add_executable(aes_project src/main.cpp)
aes_configure(aes_project)
target_link_libraries(aes_project PRIVATE aes_harness)

# --- Tests --------------------------------------------------------------------
enable_testing()
foreach(t test_vectors test_differential test_controls)
  add_executable(${t} tests/${t}.cpp)
  aes_configure(${t})
  target_link_libraries(${t} PRIVATE aes_core)
  add_test(NAME ${t} COMMAND ${t})
endforeach()
