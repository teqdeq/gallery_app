
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include <iostream>
#include <cstdlib>
#include <ctime>
//#include "plane0.hpp"
//#include "plane1.hpp"
//#include "plane2.hpp"

using namespace cv;
using namespace std;

// Convert image from YUV (flutter) color space to BGR(OpenCV) 
Mat yuv2bgr(
	uint8_t* plane0Bytes, uint8_t* plane1Bytes, uint8_t* plane2Bytes,
	int width, int height,
	int bytesPerRowPlane0 = 1, int bytesPerRowPlane1 = 2, int bytesPerRowPlane2 = 2,
	int bytesPerPixelPlane0 = 1, int bytesPerPixelPlane1 = 2, int bytesPerPixelPlane2 = 2
	) {
	 
	Mat yplane , uplane, vplane , uvplane, image, rotImage, rotyplane, yplane3Chan;

	if(bytesPerPixelPlane0 == 1){
		yplane = Mat(height , width, CV_8U, plane0Bytes);
	} else if(bytesPerPixelPlane0 == 2) {
		yplane = Mat(height , width, CV_16U, plane0Bytes);
	} else {}

	if(bytesPerPixelPlane1 == 1){
		uplane  = Mat(height/2, width /2, CV_8U, plane1Bytes);
	} else if(bytesPerPixelPlane1 == 2) {
		uplane  = Mat(height/2, width /2, CV_16U, plane1Bytes);
	} else {}

	if(bytesPerPixelPlane2 == 1){
		vplane  = Mat(height/2, width /2, CV_8U, plane2Bytes);
	} else if(bytesPerPixelPlane2 == 2) {
		vplane  = Mat(height/2, width /2, CV_16U, plane2Bytes);
	} else {}


	cvtColorTwoPlane(yplane, vplane, image,90);


	// By default , all images are taken in portrait orientation
	// Check if the image is portrait or not then rotate it if necessary
	if(height / width < 1){
		rotate(image, rotImage, ROTATE_90_CLOCKWISE);
		rotate(yplane, rotyplane, ROTATE_90_CLOCKWISE);

	}else {
		rotImage = image;
		rotyplane = yplane;
	}

	vector<Mat> copies = {rotyplane, rotyplane, rotyplane};
	merge(copies, rotyplane);

	// imshow("ymage", rotyplane);
	// waitKey(0);

	// resize(rotyplane, rotyplane, Size(1920, 2560));

	cout<<"Color space conversion complete complete"<<endl;

	// setting original image
	Mat reconstructedImage = rotImage.clone();

    return reconstructedImage;
	
}
