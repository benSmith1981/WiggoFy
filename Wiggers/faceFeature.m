//
//  UIButton+isSelected.m
//  Wiggers
//
//  Created by Ben on 9/27/12.
//
//

#import "faceFeature.h"

@implementation faceFeature
@synthesize featureImageView;

-(faceFeatureType)isOfType{
    return featureType;
}

-(void)setType:(faceFeatureType)type{
    featureType = type;
}


@end
