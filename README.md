# flutter_opencv_cloud_plugin

A new Flutter plugin project.

## Getting Started

## Creating a plugin
- Run flutter create --org com.example --template=plugin --platforms=<comman separated platforms> <plugin name>

## Configuration
- Copy the opencv dynamic libraries (.so files) to the following directories
```
	<Plugin root directory>\android\src\main\cmakeLibs\arm64-v8a
	<Plugin root directory>\android\src\main\cmakeLibs\armeabi-v7a
	<Plugin root directory>\android\src\main\cmakeLibs\x86
	<Plugin root directory>\android\src\main\cmakeLibs\x86_64
```
- Add a "CMakeLists" file to "<plugin root directory>\android". The CMakeLists file should be of the following structure
```
cmake_minimum_required(VERSION 3.0.0)
include_directories(../include)
add_library(lib_opencv SHARED IMPORTED)
set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cmakeLibs/${ANDROID_ABI}/libopencv_java4.so)

//Add source files
add_library(<lib_name> SHARED ../ios/Classes/<lib_name>.cpp)

find_library(log-lib log)
target_link_libraries(<lib_name> lib_opencv ${log-lib})

```
- Store all source files in ../ios/Classes/ or plugin root>/ios/Classes/ directories

- Make sure the folder <plugin root>/include/opencv2 exists and contains the Opencv libraries

- Add the following code to the "<plugin root dir>/android/" section of the <plugin root>/android/buil.gradle file:
```
    lintOptions {
        disable 'InvalidPackage'
    }

    defaultConfig {
        externalNativeBuild {
            cmake {
                // Enabling exceptions, RTTI
                // And setting C++ standard version
                cppFlags '-frtti -fexceptions -std=c++11'

                // Shared runtime for shared libraries
                arguments "-DANDROID_STL=c++_shared"
            }
        }
    }

    externalNativeBuild {
        cmake {
            path "CMakeLists.txt"
            version "3.10.2.4988404" //The cmake version installed on your computer
        }

        ndkVersion = "23.1.7779620" //Specify the ndk version installed on your computer
    }
```
- Add the following dependencies to your pubspec.yaml file

	ffi, image_picker, camera, path_provider or any other if necessary


## Using the plugin in another flutter application

- In the "android" section of the <project dir>/android/build.gradle add the following lines of code
```
    externalNativeBuild {
        cmake {
            version "3.10.2.4988404" //The same CMake version as in the plugin
        }
    }

    ndkVersion = "23.1.7779620" //The same ndk version as in the plugin
```
- In the <project dir>/android/app/build.gradle change the min sdk version to 21
