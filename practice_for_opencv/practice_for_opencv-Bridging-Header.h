//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageConverter : NSObject
+(UIImage *)getBinaryImage:(UIImage *)image colormap:(int)colormap thresh:(float)thresh maxval:(float)maxval thresholdtype:(int)thresholdtype algorithmtype:(int)algorithmtype;

+(UIImage *)getdetectedImage:(UIImage *)image threshold1:(float)threshold1 threshold2:(float)threshold2;


@end
