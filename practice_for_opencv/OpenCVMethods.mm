//
//  OpenCVMethods.mm
//  practice_for_opencv
//
//  Created by 黃麒安 on 2019/6/25.
//  Copyright © 2019 黃麒安. All rights reserved.
//


#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc.hpp>
#import "practice_for_opencv-Bridging-Header.h"

@implementation ImageConverter : NSObject


+(UIImage *)getdetectedImage:(UIImage *)image threshold1:(float)threshold1 threshold2:(float)threshold2{
    
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    cv::Mat edges;
    cv::Canny(mat, edges, threshold1, threshold2);
    
    
    UIImage *finalImg = MatToUIImage(edges);
    return finalImg;
}

@end

