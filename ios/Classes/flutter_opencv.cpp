#include <stdint.h>
#include <opencv2/opencv.hpp>
#include "image_matcher.hpp"
#include "yolo.hpp"


// Add all C/C++ functions
extern "C" __attribute__((visibility("default"))) __attribute__((used))
float native_add(float num1, float num2) {
 return num1 + num2;
}



// Functions for image matching
extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t loadDescriptors(char** imagePathsPrimitive, char* featuresFilePath, int pathCount) {
    _loadDescriptors(imagePathsPrimitive, featuresFilePath, pathCount);
    return loadDescriptorResult;
}


extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t findBestMatch(
	uint8_t* plane0Bytes, uint8_t* plane1Bytes, uint8_t* plane2Bytes,
	int width, int height,
	int bytesPerRowPlane0 = 1, int bytesPerRowPlane1 = 2, int bytesPerRowPlane2 = 2,
	int bytesPerPixelPlane0 = 1, int bytesPerPixelPlane1 = 2, int bytesPerPixelPlane2 = 2
	) {
       return _findBestMatchYUV(
                plane0Bytes, plane1Bytes, plane2Bytes,
                width, height,
                bytesPerRowPlane0, bytesPerRowPlane1, bytesPerRowPlane2,
                bytesPerPixelPlane0, bytesPerPixelPlane1, bytesPerPixelPlane2
       );
    }


extern "C" __attribute__((visibility("default"))) __attribute__((used))
void loadYolo(char* model, char* config, bool useEmbeddedModel, int classCount) {
    _loadYolo(model, config, useEmbeddedModel, classCount);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int runYolo(
    uint8_t* plane0Bytes, uint8_t* plane1Bytes, uint8_t* plane2Bytes,
	int width, int height,
    float* boxesPointer,
	int bytesPerRowPlane0 = 1, int bytesPerRowPlane1 = 2, int bytesPerRowPlane2 = 2,
	int bytesPerPixelPlane0 = 1, int bytesPerPixelPlane1 = 2, int bytesPerPixelPlane2 = 2
) {


     return _runYoloYUV(plane0Bytes, plane1Bytes, plane2Bytes,
                        width, height,
                        boxesPointer,
                        bytesPerRowPlane0, bytesPerRowPlane1, bytesPerRowPlane2,
                        bytesPerPixelPlane0, bytesPerPixelPlane1, bytesPerPixelPlane2);

}