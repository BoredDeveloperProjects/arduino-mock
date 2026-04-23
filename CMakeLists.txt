cmake_minimum_required(VERSION 3.16...4.2)

project(arduino_mock)

find_package(Threads REQUIRED)

# If we are a stand-alone project (not included via add_subdirectory)
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
    if(NOT TARGET gmock_main)
        include(FetchContent)

        FetchContent_Declare(googletest
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG v1.17.0
        )
        FetchContent_MakeAvailable(googletest)
    endif()
endif()

add_library(arduino_mock STATIC
    src/Arduino.cc
    src/EEPROM.cc
    src/OneWire.cc
    src/Serial.cc
    src/Spark.cc
    src/Wire.cc
    src/IRremote.cc
    src/SPI.cc
    src/SoftwareSerial.cc
    src/WiFi.cc
    src/serialHelper.cc
)

target_include_directories(arduino_mock
    PRIVATE "include"
    PUBLIC "include/arduino-mock"
    INTERFACE "include/arduino-mock"
)

target_link_libraries(arduino_mock
    gmock
    gtest
    Threads::Threads
)

target_compile_features(arduino_mock PUBLIC cxx_std_11)
set_target_properties(arduino_mock PROPERTIES CXX_EXTENSIONS OFF)

set_target_properties(arduino_mock
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

# Standard CMake testing option
include(CTest)

if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(test)
endif()