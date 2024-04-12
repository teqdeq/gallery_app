cmake_minimum_required(VERSION 3.0.0)
include_directories(../include)
add_library(lib_opencv SHARED IMPORTED)
set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cmakeLibs/${ANDROID_ABI}/libopencv_java4.so)

# add_library(native_add SHARED ../ios/Classes/native_add.cpp)

add_library(flutter_opencv SHARED ../ios/Classes/flutter_opencv.cpp)
target_link_libraries(flutter_opencv lib_opencv)

find_library(log-lib log)
target_link_libraries(flutter_opencv lib_opencv ${log-lib})