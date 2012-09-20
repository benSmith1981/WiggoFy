//
//  ImageProcessing.m
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageProcessing.h"

@implementation ImageProcessing


+(void)processFace:(UIImage*)faceImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        CIImage *imageToScan = [[CIImage alloc]initWithImage:faceImage];
        
        NSString *accuracy = CIDetectorAccuracyHigh;
        NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
        
        
        NSArray *features = [detector featuresInImage:imageToScan];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithObject:features forKey:@"features"]; 
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:@"featuresNotification" 
             object:self userInfo:dict];
            //imageManip.viewController = self;
            //            [imageManip drawImageAnnotatedWithFeatures:features];
        });
        
    });  
//    CIImage *imageToScan = [[CIImage alloc]initWithImage:faceImage];
//    
//    NSString *accuracy = CIDetectorAccuracyHigh;
//    NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
//    
//    
//    NSArray *features = [detector featuresInImage:imageToScan];
//    return features;
}
@end
