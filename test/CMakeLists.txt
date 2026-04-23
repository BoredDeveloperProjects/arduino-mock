message("building tests for Arduino Mock")
# include_directories(${GTEST_INCLUDE_DIRS})
file(GLOB SRCS *.cc)

add_executable(test_all test_all.cc)

target_link_libraries(test_all
    arduino_mock
    gmock
    gtest
    Threads::Threads
)

add_test(arduino_mock_test test_all)
