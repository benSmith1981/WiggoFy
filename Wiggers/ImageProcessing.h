//
//  ImageProcessing.h
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProcessing : NSObject{
    NSMutableArray *featuresDetected;
}

+(void)processFace:(UIImage*)faceImage;
@end
