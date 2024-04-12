#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

dnn::Net net;
float min_confidence = 0.75;

float iou(Rect2d box1, Rect2d box2) {
    float intersection_area = (box1 & box2).area();
    float union_area = box1.area() + box2.area() - intersection_area;
    return intersection_area / union_area;
}

vector<Rect2d> nms(vector<Rect2d> boxes, float threshold) {
    vector<Rect2d> keep;
    sort(boxes.begin(), boxes.end(), [](Rect2d a, Rect2d b) { return a.br().x > b.br().x; });

    while (!boxes.empty()) {
        auto box = boxes.back();
        boxes.pop_back();
        keep.push_back(box);

        vector<Rect2d> suppressed;
        for (const auto &other : boxes) {
            if (iou(box, other) < threshold) {
                suppressed.push_back(other);
            }
        }
        boxes = suppressed;
    }

    return keep;
}

vector<string> classes = {
        "person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck", "boat",
        "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird",
        "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra",
        "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase",
        "frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat",
        "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle",
        "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple",
        "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut",
        "cake", "chair", "sofa", "pottedplant", "bed", "diningtable", "toilet",
        "tvmonitor", "laptop", "mouse", "remote", "keyboard", "cell phone",
        "microwave", "oven", "toaster", "sink", "refrigerator", "book", "clock",
        "vase", "scissors", "teddy bear", "hair drier", "toothbrush"
    };


void _loadYolo(string model, string config, bool useEmbeddedModel, int classCount ) {

    string defaultConfig = "./yolov2-tiny.cfg";
    string defaultWeights = "./yolov2-tiny.weights";
    // Load weights and construct graph
    if(useEmbeddedModel == true) {
        net = dnn::readNetFromDarknet(defaultConfig, defaultWeights);
    } else {
        net = dnn::readNetFromDarknet(config, model);
    }
    // net.setPreferableBackend(dnn::DNN_BACKEND_DEFAULT);
    // net.setPreferableTarget(dnn::DNN_TARGET_CPU);
}


int _runYoloYUV(uint8_t* plane0Bytes, uint8_t* plane1Bytes, uint8_t* plane2Bytes,
        int width, int height,
        float* boxesPointer,
        int bytesPerRowPlane0 = 1, int bytesPerRowPlane1 = 2, int bytesPerRowPlane2 = 2,
        int bytesPerPixelPlane0 = 1, int bytesPerPixelPlane1 = 2, int bytesPerPixelPlane2 = 2)
    {

    Mat frame;

    /*
        Don't forget to uncomment these lines of code
    */
     frame =  yuv2bgr(
                 plane0Bytes, plane1Bytes, plane2Bytes,
                 width, height,
                 bytesPerRowPlane0, bytesPerRowPlane1, bytesPerRowPlane2,
                 bytesPerPixelPlane0, bytesPerPixelPlane1, bytesPerPixelPlane2
        );

    // Get width and height
    // int height = frame.rows;
    // int width = frame.cols;

    // Create a 4D blob from a frame.
    Mat blob = dnn::blobFromImage(frame, 1.0 / 255.0, Size(416, 416), Scalar(0, 0, 0), true, false);
    net.setInput(blob);
    // Run the preprocessed input blog through the network
    Mat predictions = net.forward();
    int probability_index = 5;

    vector<Rect2d> boxes;
    vector<int> predictionIndices;
    vector<float> confidences;
    // vector<string> predictions;
    for (int i = 0; i < predictions.size[0]; i++) {
        Mat prob_arr = predictions.row(i).colRange(probability_index, predictions.size[1]);
        Point class_index;
        minMaxLoc(prob_arr, 0, 0, 0, &class_index);
        float confidence = prob_arr.at<float>(class_index);

        if (confidence > min_confidence) {
            float x_center = predictions.at<float>(i, 0) * width;
            float y_center = predictions.at<float>(i, 1) * height;
            float width_box = predictions.at<float>(i, 2) * width;
            float height_box = predictions.at<float>(i, 3) * height;

            int x1 = static_cast<int>(x_center - width_box * 0.5);
            int y1 = static_cast<int>(y_center - height_box * 0.5);
            int x2 = static_cast<int>(x_center + width_box * 0.5);
            int y2 = static_cast<int>(y_center + height_box * 0.5);

            boxes.push_back(Rect2d(x1, y1, x2 - x1, y2 - y1));
            predictionIndices.push_back(class_index.x);
            confidences.push_back(confidence);
        }
    }

    cout<<"Predictions successfully extracted"<<endl;

    vector<Rect2d> newBoxes = nms(boxes, 0.5);
    vector<int> newPredictionIndices;
    vector<float> newConfidences;

    for(auto newBox : newBoxes) {
        for(int idx = 0; idx < boxes.size(); idx++) {
            ///check if boxes match
            Rect2d box = boxes[idx];
            if(newBox.x == box.x && newBox.y == box.y && newBox.width == box.width && newBox.height == box.height) {
                newPredictionIndices.push_back(predictionIndices[idx]);
                newConfidences.push_back(confidences[idx]);
            }
        }
    }
    cout<<"Extracted new boxes and their classes"<<endl;

    cout<<"All boxes size: "<<boxes.size()<<endl;
    cout<<"New boxes size: "<<newBoxes.size()<<endl;

    cout<<"Drawing bounding boxes"<<endl;
    for (int j = 0; j < newBoxes.size(); j++) {
    int startIndex = j * 6;
        Rect2d box = newBoxes[j];
        cout<<"x: "<<box.x<<"   y: "<<box.y<<"   width: "<<box.width<<"   height: "<<box.height<<endl;
        // rectangle(frame, box, Scalar(255, 255, 255), 1);
        // putText(frame, classes[newPredictionIndices[j]], Point(box.x, box.y), FONT_HERSHEY_SIMPLEX, 1, Scalar(255, 255, 255), 1, LINE_AA);

        // Adding box data to boxesPointer
        float newBoxData[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        boxesPointer[startIndex + 0] = box.x; //set topleft x coordinate
        boxesPointer[startIndex + 1] = box.y; //set topleft y coordinate
        boxesPointer[startIndex + 2] = box.width; // set box width
        boxesPointer[startIndex + 3] = box.height; //set box height
        boxesPointer[startIndex + 4] = newPredictionIndices[j] * 1.0; //set predicted class index
        boxesPointer[startIndex + 5] = newConfidences[j]; // set class confidence
        // boxesPointer[j] = newBoxData; // add newBoxData to boxesPointer

    }

    return newBoxes.size();
}




