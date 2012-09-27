//
//  UIButton+isSelected.h
//  Wiggers
//
//  Created by Ben on 9/27/12.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface faceFeature : NSObject{
    faceFeatureType featureType;
}

@property (nonatomic, strong)UIImageView *featureImageView;

-(faceFeatureType)isOfType;
-(void)setType:(faceFeatureType)type;

@end
